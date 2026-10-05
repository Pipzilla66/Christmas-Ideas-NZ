# Christmas Ideas NZ app build

The existing repository content has been left in place.

The mobile app build is stored as a compressed source bundle in `app_source_bundle.b64`. GitHub Actions restores that bundle, generates the Android Flutter project files and builds a debug APK.

## Android test build

Open **Actions** in GitHub and select **Build Christmas Ideas NZ Android APK**. The workflow also runs automatically when the bundle or workflow changes.

When it succeeds, download the `christmas-ideas-nz-debug-apk` artifact from the workflow run.

The app connects to the Christmas Ideas NZ Supabase project using its public/publishable client key. No database password or service-role key is stored here.
