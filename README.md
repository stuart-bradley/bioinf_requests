
<img style="vertical-align: middle;" width="300" src="https://raw.githubusercontent.com/lutrasdebtra/bioinf_requests/master/public/assets/BurP.png">


## BuRP (Bioinformatics Request Portal) - Overview

BuRP is a ticketing system designed with biological computing and bioinformatics workflows in mind. It uses an admin-customer
hierarchy for request creation and assignment, and has a fully integrated LDAP, email, and analytics components. 

Screencaps of the various views can be found in the [`\screenshots` folder](https://github.com/lutrasdebtra/bioinf_php_poem/tree/master/screenshots).

### General Features

* **Request**:
  * Initial fields:
    * Title.
    * Description.
    * Priority - Priority order can be quickly viewed on the man page.
    * Customer attachments.
  * Admin fields:
    * Status (Pending, Ongoing, Complete)
    * Assignment - Single or multiple.
    * Customer.
    * Result.
    * Result attachments.
* Emailer - Including threaded sending.
* Versioning.
* Individual user pages.
* Individual and group analytics pages. 
* Unit and integration tests.

## Installation

Installation is not at this stage particularly seemless, as the system is setup for one specific company. 
However, I will explain how to configure the various components. 

```
git clone https://github.com/lutrasdebtra/bioinf_requests
cd /bioinf_php_poem
```

### Prerequisites 

Since BuRP is a Ruby-On-Rails application, it relies on Ruby and a few gems:
* Ruby V2.2.2.
* Gems:
  * Ruby-On-Rails V5.2.
  * Bundler.
* MySQL.
  
### Gem Installation

```
bundle install
```


### Secrets

The `config\secrets.yml` file should be as follows:

```YAML
common: &common
  mailer_email: 'test@test.com'
  mailer_password: 'password'
  mailer_host: "http://test.local:3000/"
  mailer_port: 3000
  mailer_smtp_address: "smtp.office365.com"
  mailer_smtp_port: 587
  mailer_smtp_domain: "test.com"
  
  MYSQL_user: 'user'
  MYSQL_password: 'password'
  
  LDAP_login: 'CN=test,OU= Accounts,OU=IT,DC=lt'
  LDAP_password: 'password'
  LDAP_IP: "10.10.10.10"
  LDAP_user_base: "OU=Users,DC=lt"
  LDAP_group_base: "OU=Departments,OU=Groups,DC=lt"

development:
  <<: *common
  MYSQL_database: 'database_dev'
  secret_key_base: secret

test:
  <<: *common
  MYSQL_database_test: 'database_test'
  secret_key_base: secret

production:
  <<: *common
  MYSQL_database: 'database'
  secret_key_base: secret

```

### Database Installation

The following commands can also be run with the `development` and `test` `RAILS_ENV` flags:

```
RAILS_ENV=production rake db:setup
```

### Misc Config

#### LDAP User Setup

Firstly, make sure `config\ldap.yml` is configured correctly.

To add users from an LDAP server, there is two rake tasks that can be performed, both under the `add_user_groups` umbrella.

Both commands invoke the `lib\tasks\user_group.rb` module, which **will** require modification before use. 
The main modification must occur at the top of the file, which holds information specific to a single LDAP server. While
this information can also be hidden, I've left an old version of the LZ data for illustrative purposes. 
The variables and their purposes are as follows:

```Ruby
@ldap_groups = {
      "Team_BioInformatics" => "Bioinformatics",
      "Team_Fermentation" => "Fermentation",
      "Team_Synthetic Biology" => "Synthetic Biology",
      "Team_Eng Process Engineering" => "Process Engineering",
      "Team_Eng Global Operations" => "Engineering",
      "Team_Eng Design Development" => "Engineering",
      "Team_Process Validation" => "Process Validation"
  } # Maps LDAP group names to BuRP group names (which may be more human readable).

  @admin_group = "Bioinformatics" # Group which all members are admins. 
  @managers = ["wayne.mitchell","asela.dassanayake"] # Usernames of managers.
  @directors = ["wayne.mitchell"] #Usernames of directors. 

  @special_cases = {"Heijstra" => "bjorn.heijstra",
                    "Sean Simpson" => "sean",
                    "Sashini De Tissera" => "sashini.detissera"} # LDAP names which have a different sAMAccountName format than 'first.last'
```

Additionally, the LDAP filters use specific attributes, which may need to be changed to match your use case further down 
the file. 

##### Commands

* `rails add_user_groups:all` - Searches LDAP for all users in the groups defined by the keys in `@ldap_groups`. 
It then creates non-existent users and updates their groups and other information accordingly. 
Pre-existing users (such as those added manually or in `seeds.rb`), will only have their groups modified. 
The command then lists users with multiple groups (which have to be dealt with manually), and any existing users without groups.
* `rails add_user_groups:some[user.name1,user.name2]` - Searches LDAP for **only** users provided and updates groups accordingly. 
This is useful for when a new user has logged in post the `all` command, and needs to be updated. An email is sent if such a user logs in
to admins, so that they are aware this needs to happen. 


## Component Information

### Emailer

To configure the emailer, set the correct values in `config\secrets.yml`, and then check that `config/enviroment.rb` and 
`app\mailers\emailer.rb` are set up and using the mailer values correctly.

The following types of mail get sent:
* New Request - This gets sent to all admins (plus the user who created it). It also states the assignment if there is one.
* Edit Request - This get sent to all **assigned** admins, plus the user who created it. Content changes based on the type of 
edit. 
* Weekly Summary - A weekly summary of Pending and Ongoing Requests is sent to each Admin. 
* No User Group Warning - If a new user logs in and isn't assigned a group, an email will be sent to suggest a manual edit.
 
The emailer system is run off of [Delayed::Job](https://github.com/collectiveidea/delayed_job) for parallel execution of mailer
threads. A full list of DJ commands can be found [here](https://github.com/collectiveidea/delayed_job#running-jobs).

### Users

The user hierarchy is as follows: 
* Directors - Can view everyone's user pages and see all analytics.
* Managers - Can view everyone's user pages **except** the directors.
* Admin - This is the main group, anyone in this group can access the admin side of requests (e.g. adding results, changing assignments etc). 
They also have access to their own personal analytics pages.
* Non-assigned - Every other user has the ability to submit and view all requests. 

This hierarchy is controlled by the gem [cancan](https://github.com/ryanb/cancan). While general user functions are provided
jointly by [Devise](https://github.com/plataformatec/devise) and [Devise LDAP Authenticatable](https://github.com/cschiewek/devise_ldap_authenticatable).

### Analytics

The analytics system provides various levels of basic analysis depending on what kind of user you are (Admin and above).
* Group analytics - Available to managers and directors. This shows the percentage makeup of requests from different user groups. 
* User analytics - Available to individual admins. Two graphs are produced:
  * Estimated vs total hours per request.
  * Days spent per stage. 
  
The graphs are produced by the [Google Charts API](https://developers.google.com/chart/).

### Testing

BuRP uses the in-built Minitest, and features extensive unit-tests, as well as integration tests that cover the main flow of the program.

These tests can simply be run with:

`rails test`

## Server commands


```
rails server -p 3000 -d -e production -b 192.168.1.1
RAILS_ENV=production bin/delayed_job start
```

Port and IP are examples.

### Rake Commands

**Note:** The lack of space between the arguments is **required**. `[arg1,arg2]` will work, but `[arg1, arg2]` will fail. 

#### `database_changes.rake`
 
This `rake` file contains two database changes that we're required during migrations of the `current_changes` and 
`assignment` fields. These are not required for general use, but are kept for posterity. 

#### `add_user_groups.rake`

Sets the `group` field for users, by querying `lib/user_groups.rb`. See **LDAP User Setup** above for further information.
`add_user_groups:some[user.name1,user.name2]` is likely to be used post initial setup. 

#### `users.rake`

The `users.rake` file allows for the modification and creation of users and their privileges. In its simplest form it 
can be run like so:

```
rails users:modify[login=user.name]
```

Which runs the database command:

```
user = where("login = ?", user.name).first
user.update!({:admin => false, :manager => false, :director => false})
```

As `false` is the default value for privileges. 

To change the defaults the command is run like so:


```
# Updates user to an admin.
rails users:modify[login=user.name,admin=true]
```

To modify a user's `group`, the value must match one already found in `lib/user_groups`:

```
# Updates user's group to Bioinformatics.
rails users:modify[login=user.name,group=Bioinformatics]
```

If the user does not exist, it is possible to create them, using the `--create` flag:

```
rails users:modify[login=user.name,admin=true,--create]
```

Which runs the database command:

```
User.create!({:login => user.name, :admin => true, :manager => false, :director => false})
```

Finally, the `--help` flag prints out the argument information inside the rails console:

```
rails users:modify[--help]
```