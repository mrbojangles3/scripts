# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rlog/rlog-1.4.ebuild,v 1.5 2010/07/03 17:18:18 armin76 Exp $

EAPI=2
inherit eutils

DESCRIPTION="A C++ logging library"
HOMEPAGE="http://code.google.com/p/rlog/"
SRC_URI="http://rlog.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.7-gcc-4.3.patch
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install || die
	dodoc AUTHORS ChangeLog README
}
