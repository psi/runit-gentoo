# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/runit/runit-2.1.1-r1.ebuild,v 1.2 2012/02/06 03:13:33 vapier Exp $

EAPI="3"

inherit toolchain-funcs flag-o-matic git-2

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://github.com/ttuegel/runit-gentoo"
EGIT_REPO_URI="git://github.com/ttuegel/runit-gentoo.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="dietlibc static"

RDEPEND="dietlibc? ( dev-libs/dietlibc )"
DEPEND="${RDEPEND}"

src_prepare() {
	# we either build everything or nothing static
	sed -i -e 's:-static: :' src/Makefile
}

src_configure() {
	local diet=""
	use dietlibc && diet="diet -Os"
	use static && append-ldflags -static

	echo "${diet} $(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "${diet} $(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	dodir /var
	keepdir /var/service
	keepdir /etc/runit{,/{boot,halt,service.avail}}

	dobin $(<../package/commands) || die "dobin"
	dodir /sbin
	mv "${D}"/usr/bin/{runit-init,runit,utmpset} "${D}"/sbin/ || die "dosbin"

	cd "${S}"/..
	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]

	exeinto /etc/runit
	doexe etc/gentoo/{1,2,3} || die
	for tty in tty1 tty2 tty3 tty4 tty5 tty6; do
		exeinto /etc/runit/service.avail/getty-$tty/
		for script in run finish; do
			newexe etc/gentoo/service.avail/getty/$script $script
			dosed "s:TTY:${tty}:g" /etc/runit/service.avail/getty-$tty/$script
		done
		dosym /etc/runit/service.avail/getty-$tty /var/service/getty-$tty
	done

	# make sv command work
	cd "${S}"
	insinto /etc/env.d
	cat <<-EOF > env.d
		#/etc/env.d/20runit
		SVDIR="/var/service/"
	EOF
	newins env.d 20runit
}

pkg_postinst() {
	ewarn "/etc/profile was updated. Please run:"
	ewarn "source /etc/profile"
	ewarn "to make 'sv' work correctly on your currently open shells"
}
