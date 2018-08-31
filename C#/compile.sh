csc main.cs | tail -n +4
printf "#!/bin/bash\nmono main.exe \$*" > program
chmod +x program
