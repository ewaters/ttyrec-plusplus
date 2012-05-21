use Module::Build;

my $build = Module::Build->new(
	module_name => 'App::ttyrecpp',
	license     => 'perl',
	sign        => 1,
	configure_requires => {
		'Module::Build' => 0.4,
	},
	build_requires => {
		'Test::More' => 0,
	},
	requires => {
		'JSON::XS'        => 0,
		'Getopt::Long'    => 0,
		'POE'             => 1.351, # POE::Wheel::Run_ttyrec was forked from here
	},
	create_makefile_pl => 'passthrough',
	create_readme      => 1,
);

$build->create_build_script;
