# Contributing

Thank you for considering contributing! Before diving into too much work, it's a good idea to have a conversation about the changes you would like to make. Since we don't have a secret Bat-phone connection to Commissioner Gordan, the easiest way to float a conversation about a feature or bug is by [creating an issue in the tracker](https://github.com/fireproofsocks/xray/issues).


## Guidelines 

1. Fork the repository, then clone your fork. Recommended: add the original repo as the upstream to ensure that you are tracking the latest changes.
2. Create a branch off of master for your bug or feature.
3. Make your code changes. It is considered best-practice (and proper coding etiquette) to keep your changes scoped to a single problem. If you're dealing with several issues, consider submitting multiple pull requests.
4. Please add tests when possible/relevant; run the existing tests via `mix test` to ensure that your changes didn't break existing functionality.
5. Run `mix format` to adjust the file formatting in a uniform way.
6. Run `mix lint` to check for any code smells in a uniform way. Adjust code as needed.
7. Before you make your pull request, it's a good idea to pull down the latest changes from the upstream master and merging these into your branch to ensure that any conflicts are properly resolved.
8. Push your local branch to your remote.
9. Open a pull request from your fork's feature or bug branch to the original's master branch. 

Note: Merge or rebase? I prefer the simplicity of merges unless you have a really compelling reason to use rebase.  When your pull request is closed, I will probably squash the commits, but I'm not too worried about having lots of commits on an open-source project.

Thank you! 