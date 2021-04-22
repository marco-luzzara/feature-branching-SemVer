# Feature branching workflow for Semantic Versioning

This is an implementation of a feature branching workflow, tailored to be used with semantic versioning and for a task-based workflow.
For these reasons, there are some important assumptions to consider:
* Each task you are working on has a (numeric for now) identifier.
* The `master` branch is the main branch, while tasks are developped in feature branches called `feature/{taskId}`.
* Each task completed corresponds to a new version of your software, in particular a semantic version, thus specified with the regular expression `(major|minor|patch)`.
* You can open and close task only if in that moment you can access the remote repository. This is quite limiting for many reasons but it also avoids situations where the same task is open/closed locally by different users.

## Create Aliases for new commands
The advantage of a simple workflow like feature-branching is that you do not need to remember many commands, in this case only 2: `git open-task` and `git close-task`.
The quickest way to extend git is by using aliases (local or global, your choice):
* For `open-task`:

      git config alias.open-task '! ./path_to_this_repo/open-task.sh'

* For `close-task`:
  
      git config alias.close-task '! ./path_to_this_repo/close-task.sh'

## How does it work?
Suppose you are on `master` and you need to work on the task 1234. This task requires the implementation of non-breaking functionalities, so the next release version is `minor`.
Starting from a sample repo, like

```
* 90b6db7 (HEAD -> master) second commit
* 7ee30a3 first commit
```

This is how you open task 1234:

    git open-task "1234" "minor"

And this is the final repo:

```
* 77cf0a5 (HEAD -> feature/1234, origin/feature/1234) branch feature/1234 started
* 90b6db7 (origin/master, master) second commit
* 7ee30a3 first commit
```

There is a new branch called `feature/1234` and the corresponding tracking branch. In the newly created branch, there are 2 files called::
* `.CI_TASKID` containing the task identifier, *1234* in this case.
* `.CI_NEXTRELEASE` containing the next release version type, *minor* in this case.

While you should not modify the first file, you can modify the second one if, during the development, you realize that you need a *patch* for example.
This files should not even be deleted, if you do not find them after pulling the most recent remote version of the feature branch, it probably means that the feature branch has already been closed.

Then you can continue working on the feature branch, and when you are confident that it is ready to be pushed, you can `close-task`, after pushing all the local commits on the feature branch.
Starting from

```
* 66ec97c (HEAD -> feature/1234, origin/feature/1234) task development
* 77cf0a5 branch feature/1234 started
* 90b6db7 (origin/master, master) second commit
* 7ee30a3 first commit
```

This is how you close a task:

    git close-task

And this is the final repo:

```
*   e972fb3 (HEAD -> master, origin/master) rif. #1234:minor:Merged branch feature/1234
|\  
| * 388c158 (origin/feature/1234, feature/1234) cleaned CI files
| * 66ec97c task development
| * 77cf0a5 branch feature/1234 started
|/  
* 90b6db7 second commit
* 7ee30a3 first commit
```

As you can see the feature branch has been merged in the `master` branch using a `--no-ff` strategy. In general, you cannot close a task if you have not merged the `master` changes in the feature branch. Rebasing them is possible of course.
The same goes for changes on the same remote feature branch.
Before closing a feature branch, the `.CI_` files are automatically deleted in a new commit and the feature branch is merged in `master` with the commit message

    rif. #{taskId}:{semanticReleaseVersionType}:{description}
    
the *description* can be specified as an argument to the `close-task` command, otherwise the default one is used.

## Repo Validation 
You can find all the tests in the *tests* folder: each `function` whose name starts with *test_* corresponds to a test, which basically sets up a repo and make some assertions after calling `open/close-task`. 
It is very possible to find some common situations there, but I invite you to create an issue if you encounter unexpected errors.

## Limits and future development
This is not a flexible workflow at all, actually it is the product of a company need. There should be the possibility to configure much of the hard-coded strings, included the feature branches naming, the remote repo name and the commit messages.
Moreover, there is space for (relatively) minor improvements like the history simplification and additional commands to revert an `open-task` for example.
Not tested with Git bash for Windows, but I expect it to be not fully supported. 

Feel free to contribute if you are interested in the project 😉

