# Docker builder for the Janus WebRTC gateway

Just builds https://github.com/meetecho/janus-gateway into a neat Docker container.
Runs as a downgraded user (non-root).

## Use root-only-accessible certificates
Provides a feature to import root-only-accessible certificates/keys during the entrypoint.
If you want to use the feature, provide environment variables `COPYCERT` and `COPYKEY` with the
paths/filenames to the certificate and/or the key already mounted into the container.
The entrypoint will automatically copy the files, change the owner of them to `janus`,
and execute janus with the downgraded user.
