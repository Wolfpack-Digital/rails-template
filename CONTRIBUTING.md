# Welcome to Wolfpack-Digital/rails-template contributing guide

In this guide you will get an overview of the contribution workflow from opening an discussion or an issue, creating a PR, reviewing, and merging the PR.

## Getting started

Everything starts from a discussion or an issue. How to choose between opening a discussion or an issue you wonder? Here are some guiding principles.

Open issues for things like:

- Bugs encountered while using the template
- Unexpected end result after using the template
- Lacking documentation
- gem deprecations
- unsupported gem version

Open a discussion for thing like:

- I think this gem should be a default for new projects and I would like to see it included in the template. What do you think?
- Questions about the usage of the template
- General ideas and suggestions for improvements.

So to summarize, unless you've encountered a reproducible problem while using the template, most likely you want to open a discussion. Discussions can lead to creation of issues and hopefully the issues get solved.

## Discussions

Discussions are where we have conversations.

If you'd like help troubleshooting, have a great new idea, or want to share something amazing you've learned regarding rails templates, join us in [discussions](https://github.com/Wolfpack-Digital/rails-template/discussions).

## Issues

[Issues](https://github.com/Wolfpack-Digital/rails-template/issues) are used to track tasks that contributors can help with. If an issue has a `triage` label, we haven't reviewed it yet and you shouldn't begin work on it.

If you've found something, search open issues to see if someone else has reported the same thing. If it's something new, open an issue using a [template](https://github.com/Wolfpack-Digital/rails-template/issues/new/choose). We'll use the issue to have a conversation about the problem you want to fix.

If an issue is ready for action and you want to start working on it. Leave a comment on the issue to let everyone know about your intention do to so. This will avoid conflicts or time wasted by multiple people on the same issue.

## Pull Requests

### Make A Branch

Please create a separate branch for each issue that you're working on.

### Push Your Code ASAP

Push your code as soon as you can. Follow the "early and often" rule.

Make a pull request as soon as you can and mark the title with a **"[WIP]"** if necessary. Or you can create a draft pull request. [How to create draft PR?](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests)

### Describe Your Pull Request

Use the format specified in pull request template for the repository. Populate the stencil completely for maximum verbosity.

Tag the actual issue number by replacing `#[issue_number]` e.g. `#42`. This closes the issue when your PR is merged.

Tag the actual issue author by replacing `@[author]` e.g. `@issue_author`. This brings the reporter of the issue into the conversation.

Mark the tasks off your checklist by adding an x in the [ ] e.g. [x]. This checks off the boxes in your to-do list. The more boxes you check, the better.

Describe your change in detail. Too much detail is better than too little.

Describe how you tested your change.

Check the Preview tab to make sure the Markdown is correctly rendered and that all tags and references are linked. If not, go back and edit the Markdown.

### Request Review

Once your PR is ready, remove the **"[WIP]"** from the title and/or change it from a draft PR to a regular PR.

If a specific reviewer is not assigned automatically, please request a review from the project maintainer and any other interested parties manually.

### Incorporating feedback

If your PR gets a 'Changes requested' review, you will need to address the feedback and update your PR by pushing to the same branch. You don't need to close the PR and open a new one.

Be sure to re-request review once you have made changes after a code review.

Asking for a re-review makes it clear that you addressed the changes that were requested and that it's waiting on the maintainers instead of the other way round.

### Merging a Pull Request

Once all the PR requirements are fulfilled the PR will get merged and the issue will be closed. Congratulations! :tada:
