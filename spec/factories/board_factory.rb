Factory.define :board do |b|
  b.title " loose-weight-#{rand.to_s[4..10]}"
  b.url   'loose-weight'
  b.is_public false
  b.user_id 1
end