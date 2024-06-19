# Copyright (c) 2017 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CROS_WORKON_PROJECT="coreos/afterburn"
CROS_WORKON_LOCALNAME="afterburn"
CROS_WORKON_REPO="https://github.com"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT="aa1be7dba724403457dee0fabed16e15be3ef4e0" # v5.6.0
	KEYWORDS="amd64 arm64"
fi

# https://github.com/gentoo/cargo-ebuild
CRATES="
	addr2line@0.22.0
	adler@1.0.2
	adler32@1.2.0
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	anstyle@1.0.7
	anyhow@1.0.86
	arc-swap@1.7.1
	assert-json-diff@2.0.2
	async-broadcast@0.5.1
	async-channel@2.3.1
	async-executor@1.12.0
	async-fs@1.6.0
	async-io@1.13.0
	async-io@2.3.3
	async-lock@2.8.0
	async-lock@3.4.0
	async-process@1.8.1
	async-recursion@1.1.1
	async-signal@0.2.8
	async-task@4.7.1
	async-trait@0.1.80
	atomic-waker@1.1.2
	autocfg@1.3.0
	backtrace@0.3.73
	base64@0.13.1
	base64@0.21.7
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	blocking@1.6.1
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.6.0
	cc@1.0.99
	cfg-if@1.0.0
	charset@0.1.3
	clap@4.5.7
	clap_builder@4.5.7
	clap_derive@4.5.5
	clap_lex@0.7.1
	colored@2.1.0
	concurrent-queue@2.5.0
	core-foundation@0.9.4
	core-foundation-sys@0.8.6
	core2@0.4.0
	cpufeatures@0.2.12
	crc32fast@1.4.2
	crossbeam-channel@0.5.13
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	dary_heap@0.3.6
	data-encoding@2.6.0
	deranged@0.3.11
	derivative@2.2.0
	digest@0.10.7
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	displaydoc@0.2.4
	encoding_rs@0.8.34
	enumflags2@0.7.10
	enumflags2_derive@0.7.10
	equivalent@1.0.1
	errno@0.3.9
	event-listener@2.5.3
	event-listener@3.1.0
	event-listener@5.3.1
	event-listener-strategy@0.5.2
	fastrand@1.9.0
	fastrand@2.1.0
	fnv@1.0.7
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-io@0.3.30
	futures-lite@1.13.0
	futures-lite@2.3.0
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	generic-array@0.14.7
	getrandom@0.2.15
	gimli@0.29.0
	h2@0.3.26
	h2@0.4.5
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	hex@0.4.3
	hmac@0.12.1
	hostname@0.4.0
	http@0.2.12
	http@1.1.0
	http-body@0.4.6
	http-body@1.0.0
	http-body-util@0.1.2
	httparse@1.9.4
	httpdate@1.0.3
	hyper@0.14.29
	hyper@1.3.1
	hyper-rustls@0.27.2
	hyper-tls@0.6.0
	hyper-util@0.1.5
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.0
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.0
	indexmap@2.2.6
	instant@0.1.13
	io-lifetimes@1.0.11
	ipnet@2.9.0
	ipnetwork@0.20.0
	is-terminal@0.4.12
	itoa@1.0.11
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.155
	libflate@2.1.0
	libflate_lz77@2.1.0
	libredox@0.1.3
	libsystemd@0.7.0
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.14
	litemap@0.7.3
	lock_api@0.4.12
	log@0.4.21
	mailparse@0.15.0
	maplit@1.0.2
	md-5@0.10.6
	memchr@2.7.4
	memoffset@0.7.1
	memoffset@0.9.1
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.4
	mio@0.8.11
	mockito@1.4.0
	native-tls@0.2.12
	nix@0.26.4
	nix@0.27.1
	no-std-net@0.6.0
	nom@7.1.3
	num-conv@0.1.0
	object@0.36.0
	once_cell@1.19.0
	openssh-keys@0.6.3
	openssl@0.10.64
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.102
	ordered-stream@0.2.0
	parking@2.2.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	percent-encoding@2.3.1
	pin-project@1.1.5
	pin-project-internal@1.1.5
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	piper@0.2.3
	pkg-config@0.3.30
	pnet_base@0.34.0
	pnet_base@0.35.0
	pnet_datalink@0.35.0
	pnet_sys@0.35.0
	polling@2.8.0
	polling@3.7.2
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	proc-macro-crate@1.3.1
	proc-macro2@1.0.85
	quote@1.0.36
	quoted_printable@0.5.0
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.5.2
	redox_users@0.4.5
	regex@1.10.5
	regex-automata@0.4.7
	regex-syntax@0.8.4
	reqwest@0.12.5
	ring@0.17.8
	rle-decode-fast@1.0.3
	rustc-demangle@0.1.24
	rustix@0.37.27
	rustix@0.38.34
	rustls@0.23.10
	rustls-pemfile@2.1.2
	rustls-pki-types@1.7.0
	rustls-webpki@0.102.4
	rustversion@1.0.17
	ryu@1.0.18
	schannel@0.1.23
	scopeguard@1.2.0
	security-framework@2.11.0
	security-framework-sys@2.11.0
	serde@1.0.203
	serde-xml-rs@0.6.0
	serde_derive@1.0.203
	serde_json@1.0.117
	serde_repr@0.1.19
	serde_urlencoded@0.7.1
	serde_yaml@0.9.34+deprecated
	sha1@0.10.6
	sha2@0.10.8
	signal-hook-registry@1.4.2
	similar@2.5.0
	slab@0.4.9
	slog@2.7.0
	slog-async@2.8.0
	slog-scope@4.4.0
	slog-term@2.9.1
	smallvec@1.13.2
	socket2@0.4.10
	socket2@0.5.7
	spin@0.9.8
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	strsim@0.11.1
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.66
	sync_wrapper@1.0.1
	synstructure@0.13.1
	system-configuration@0.5.1
	system-configuration-sys@0.5.0
	take_mut@0.2.2
	tempfile@3.10.1
	term@0.7.0
	terminal_size@0.3.0
	thiserror@1.0.61
	thiserror-impl@1.0.61
	thread_local@1.1.8
	time@0.3.36
	time-core@0.1.2
	time-macros@0.2.18
	tinystr@0.7.6
	tokio@1.38.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.26.0
	tokio-util@0.7.11
	toml_datetime@0.6.6
	toml_edit@0.19.15
	tower@0.4.13
	tower-layer@0.3.2
	tower-service@0.3.2
	tracing@0.1.40
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	try-lock@0.2.5
	typenum@1.17.0
	uds_windows@1.1.0
	unicode-ident@1.0.12
	unsafe-libyaml@0.2.11
	untrusted@0.9.0
	url@2.5.1
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	uuid@1.8.0
	uzers@0.11.3
	vcpkg@0.2.15
	version_check@0.9.4
	vmw_backdoor@0.2.4
	waker-fn@1.2.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.92
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-shared@0.2.92
	web-sys@0.3.69
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows@0.52.0
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	winnow@0.5.40
	winreg@0.52.0
	write16@1.0.0
	writeable@0.5.5
	xdg-home@1.2.0
	xml-rs@0.8.20
	yoke@0.7.4
	yoke-derive@0.7.4
	zbus@3.15.2
	zbus_macros@3.15.2
	zbus_names@2.6.1
	zerocopy@0.7.34
	zerocopy-derive@0.7.34
	zerofrom@0.1.4
	zerofrom-derive@0.1.4
	zeroize@1.8.1
	zerovec@0.10.2
	zerovec-derive@0.10.2
	zvariant@3.15.2
	zvariant_derive@3.15.2
	zvariant_utils@1.0.1
"

inherit cargo cros-workon systemd

DESCRIPTION="A tool for collecting instance metadata from various providers"
HOMEPAGE="https://github.com/coreos/afterburn"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-libs/openssl:0="

RDEPEND="
	${DEPEND}
	!coreos-base/coreos-metadata
"

PATCHES=(
	"${FILESDIR}"/0001-Revert-remove-cl-legacy-feature.patch
	"${FILESDIR}"/0002-util-cmdline-Handle-the-cmdline-flags-as-list-of-sup.patch
	"${FILESDIR}"/0003-Cargo-reduce-binary-size-for-release-profile.patch
)

src_unpack() {
	cros-workon_src_unpack
	cargo_src_unpack
}

src_prepare() {
	default

	# tell the rust-openssl bindings where the openssl library and include dirs are
	export PKG_CONFIG_ALLOW_CROSS=1
	export OPENSSL_LIB_DIR=/usr/lib64/
	export OPENSSL_INCLUDE_DIR=/usr/include/openssl/
}

src_compile() {
	cargo_src_compile --features cl-legacy
}

src_install() {
	cargo_src_install --features cl-legacy
	mv "${D}/usr/bin/afterburn" "${D}/usr/bin/coreos-metadata"

	systemd_dounit "${FILESDIR}/coreos-metadata.service"
	systemd_dounit "${FILESDIR}/coreos-metadata-sshkeys@.service"
}

src_test() {
	cargo_src_test --features cl-legacy
}
