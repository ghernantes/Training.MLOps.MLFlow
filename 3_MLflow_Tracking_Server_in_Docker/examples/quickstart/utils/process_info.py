def print_process_info(process_id):

    # Get process information using the /proc filesystem
    with open(f"/proc/{process_id}/status") as f:
        process_info = f.readlines()

    # Extract the process name, status, and owner from the process information
    for line in process_info:
        if line.startswith("Name:"):
            process_name = line.split(":")[1].strip()
        elif line.startswith("State:"):
            process_state = line.split(":")[1].strip()
        elif line.startswith("Uid:"):
            process_uid = int(line.split(":")[1].strip().split()[0])

    # Get the username of the process owner
    with open("/etc/passwd") as f:
        passwd_info = f.readlines()

    for line in passwd_info:
        if line.startswith(f"uid={process_uid}"):
            process_owner = line.split(":")[0]
            break
        elif line.find(f":{process_uid}:")>0:
            process_owner = line.split(":")[0]
            break

    # Print the process information
    print(f"Process ID: {process_id}")
    print(f"Process Name: {process_name}")
    print(f"Process Status: {process_state}")
    print(f"Process UID: {process_uid}")
    print(f"Process Owner: {process_owner}")