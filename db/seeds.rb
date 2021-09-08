User.create!([
  {email: 'admin@example.com',password: 'password', role: 'admin', firstname: 'admin', lastname: 'admin', username: 'admin'},
  {email: 'buyer@example.com', password: 'password', role: 'buyer', firstname: 'buyer', lastname: 'buyer', username: 'buyer'},
  {(email: 'broker@example.com', password: 'password', role: 'broker', firstname: 'broker', lastname: 'broker', username: 'broker')
    .update_column(:role, 'broker')},
  {(email: 'broker2@example.com', password: 'password', role: 'broker', firstname: 'broky', lastname: 'broky', username: 'broker2')
    .update_column(:role, 'broker')}
])

