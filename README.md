I would like to inform you that we have successfully executed the disaster recovery exercise on the UAT environment. The active machine is now ilcuatap02, and ilcuatap01 should not be used to start any services. Additionally, the DNS is currently pointing to ilcuatap02, and all Autosys jobs that were previously running on ilcuatap01 have been switched to ilcuatap02.

Please conduct all necessary tests this week to identify any potential issues before we apply the disaster recovery exercise in the production environment.

Furthermore, we have discovered several projects and scripts deployed on the machine that are not versioned in any Git repository. These include:

eod_replay.sh
ilc-sender
ilc-api-bir-mq-tool
Kindly inform us if these files are being used by any applications so we can include them in the disaster recovery process.

Additionally, we found that some services, including service integrator and advices integrator, are deployed in versions that do not adhere to the standard norms. These versions are not versioned on Nexus and are also deployed in production.

Lastly, for the EWS service, the checksum does not match between the version on Nexus and the one in production. Please avoid making direct modifications to the jars. For any deployment, ensure that the versions deployed are consistent with those on Nexus.

Thank you for your attention to these matters. Please let me know if you need any further clarification.

Best regards,
