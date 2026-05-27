# View the current primary group
id 
id -gn # primary group name
# create a file and see which groups inherits touch
touch ~/test_inherited_group.txt
ls -ls ~/test_inherited_group.txt
echo "Current group: $(id -gn)"
# create a new file before newgrp
touch ~/before_newgrp.txt
ls -la ~/before_newgrp.txt
