use inc::Module::Install;
all_from 'lib/Data/Section/Simple.pm';
readme_from('lib/Data/Section/Simple.pm');
build_requires 'Test::More', 0.88;
test_requires 'Test::Requires';
auto_set_repository();
WriteAll;
