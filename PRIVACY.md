# OpenHealth privacy summary

OpenHealth reads Google Health activity, sleep, HRV, resting heart rate, and paired-device sync time only after you connect your Google account and grant those read scopes. It may read equivalent Apple Health data after you grant HealthKit access. It uses these values to show your rings, widgets, and answers to questions you ask.

OpenHealth calls the Google Health API directly from the iPhone. Google OAuth tokens are stored in the iPhone Keychain. Daily widget totals and goals are stored locally in an App Group shared with OpenHealth's widget extension. OpenHealth does not operate a server that receives your health data, does not sell it, and does not use it for advertising. When available, Apple's on-device Foundation Models process questions on the device.

Disconnecting Google Health deletes OpenHealth's stored Google tokens and clears its cached Google totals. Deleting the app removes its local data. Water that OpenHealth wrote to Apple Health remains in Health until you remove it there.

OpenHealth's use of information received from the Google Health API adheres to the Google Health API Developer and User Data Policy, including its Limited Use requirements.

For questions about this personal OpenHealth build, contact prasanthdendukuri@gmail.com.
