Pod::Spec.new do |s|
  s.name = 'DataSource'
  s.version = '1.0.2'
  s.summary = 'A Swift framework that helps to deal with sectioned collections of collection items in an MVVM fashion.'
  s.homepage = 'https://github.com/Fueled/DataSource'
  s.license = {
    type: 'MIT',
    file: 'LICENSE',
  }
  s.authors = 'Fueled'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_version = '5'
  s.source = {
    git: 'https://github.com/Fueled/DataSource.git',
    tag: s.version,
  }
  s.source_files = 'DataSource/**/*.swift'
  s.osx.exclude_files = 'DataSource/**/TableView*.swift', 'DataSource/**/CollectionView*.swift', 'DataSource/**/DataSourceCellDescriptor.swift'
end
