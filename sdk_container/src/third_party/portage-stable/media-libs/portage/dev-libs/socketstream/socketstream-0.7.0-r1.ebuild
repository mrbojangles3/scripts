# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/socketstream/socketstream-0.7.0-r1.ebuild,v 1.6 2008/06/16 20:14:10 dev-zero Exp $

inherit eutils

DESCRIPTION="C++ Streaming sockets library"
HOMEPAGE="http://socketstream.sourceforge.net/"
SRC_URI="mirror://sourceforge/socketstream/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ppc ~sparc x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# include/Makefile uses DIST_SUBDIRS and thus headers dont get installed
	sed -i 's|^DIST_\(SUBDIRS =\)|\1|' include/Makefile.in || \
		die "sed include/Makefile.in failed"

	epatch "${FILESDIR}/${PV}-missing_includes.patch"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

	if use doc ; then
		emake doxygen || die "failed to build docs"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README* HACKING TODO
	use doc && dohtml -r docs/html/*
}
