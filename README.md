

# Mina::Secrets

Plugin for Mina that helps handling secrets files (those that are not stored in repo). 

Typical candidates are `master.key`, `database.yml`, `.env` etc. Anything you usualy create/upload manually during initial setup.

## Installation & Usage

Add this line to your application's Gemfile:

```rb
gem 'mina-secrets-transfer', require: false
```

And then execute:

```shell
$ bundle
```

Require `mina/secrets` in your `config/deploy.rb`:

```rb
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/secrets'

...

task :setup do
  ...
end

desc 'Deploys the current version to the server.'
task :deploy do
  ...
end
```


Update setup task:

```rb
# config/deploy.rb

desc 'Deploys the current version to the server.'
task :setup do
  ...
  # add new task
  invoke :'secrets:upload'
  ...
end
```

## Configuration

* `secrets_files` - list of secrets files (`["config/master.key", "config/credentials/#{fetch(:rails_env)}.key"]` by default)

Keep in mind that directories must be present in `shared_dirs`. All paths are relative to app root locally and to `shared_dir` on remote server.

## Tasks
| Name                    | Description
|-------------------------|----------------------------------------------------------------------------------------
|`secrets:upload`         | Safely upload secrets files to the server. Missing local files do not throw an exception. Existing remote files are NOT overwritten.
|`secrets:upload:force`   | Upload secrets files to the server. Missing local files do not throw an exception. Existing remote files ARE overwritten.
|`secrets:download`       | Safely download secrets files from the server. Missing local files are NOT overwritten. Missing remote files do not throw an exception.
|`secrets:download:force` | Download secrets files from the server. Missing local files ARE overwritten. Missing remote files do not throw an exception.

Use download tasks when you reinstall your local environment

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
