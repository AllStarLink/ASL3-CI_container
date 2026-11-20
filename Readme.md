# AllStarLink Asterisk CI
AllStarLink Asterisk container start point for CI

When generating a new release, updates should be made to the .github/workflows/publish.yml to the current Asterisk and ASL versions.
This will "pre-build" the environment saving time on the every CI run in the app_rpt workflow.
