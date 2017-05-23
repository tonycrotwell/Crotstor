# Crotstor
Scripts Used In the CrotStor project. A cloud migration appliance that presents a common front end for data migration to S3.

The CrotStor Cloud Archive Appliance is a simple server with local storage that serves as an intermediary between local storage and S3 buckets within the AWS cloud environment.  Once the server is configured with the install script, clients should be able to connect from the local network as a NAS gateway (either NFS or CIFS).  As data is moved into the appliance locally, it is synced with an S3 bucket continuously in the backend.

This is a Whiptail Script.

This Version Is Built To Run On CentOS.

To RUN:

1. Build out an Ubuntu Server.
2. Verify connectivity to the public internet
3. Download the crotstor_install.sh script (review for custom local modifications)
4. ADD CONTENT for CIFS/NFS Exports
5. ADD
