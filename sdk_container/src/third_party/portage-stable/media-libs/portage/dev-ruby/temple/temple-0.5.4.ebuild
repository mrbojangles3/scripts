# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/temple/temple-0.5.4.ebuild,v 1.2 2012/11/25 18:49:32 tomka Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES EXPRESSIONS.md README.md"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="An abstraction and a framework for compiling templates to pure Ruby."
HOMEPAGE="http://github.com/judofyr/temple"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bacon dev-ruby/tilt )"

each_ruby_test() {
	${RUBY} -S bacon -Ilib -Itest --automatic --quiet || die
}
