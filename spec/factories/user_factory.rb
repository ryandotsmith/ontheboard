Factory.define :user do |u|
  u.name 'Todd Billings'
  u.email {|a| "#{a.name}@ebay.com".downcase.delete " " }
  u.login 'toddy'
  u.password 'monkey'
  u.password_confirmation 'monkey'
  u.activated_at '2008-11-22 12:13:59'
  u.activation_code nil
  u.salt '356a192b7913b04c54574d18c28d46e6395428ab'
  u.crypted_password 'df42adbd0b4f7d31af495bcd170d4496686aecb1'
  u.created_at '2008-11-22 12:13:59'
end