```
vagrant up
vagrant provision # And reload as directed
vagrant ssh
```

In the VM:
```
cd /vagrant
rake
```

For more detailed debugging:
```
cd ruby-code
gdb ruby
```

Then in GDB:
```
run test.rb
```