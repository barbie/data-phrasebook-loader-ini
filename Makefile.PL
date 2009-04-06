use ExtUtils::MakeMaker;
WriteMakefile(
    NAME            => 'Data::Phrasebook::Loader::Ini',
    VERSION_FROM    => 'lib/Data/Phrasebook/Loader/Ini.pm',
    PREREQ_PM		=> {
		'Data::Phrasebook' => '0.18',
        'Config::IniFiles' => '0',
        'Test::More'       => '0.47',
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM => 'lib/Data/Phrasebook/Loader/Ini.pm',
       AUTHOR        => 'Barbie <barbie@cpan.org>') : ()),
);
