---
title: "GCP Cloud Functions with Scala.js in 10 lines(ish)"
date: 2019-11-17 00:00:00
featured_image: '/images/gcp-scalajs-nodejs-cloud.jpg'
excerpt: It's easy to spin up a node.js runtime on Google Cloud Platform's Cloud Functions, 
         but say you want to write in Scala instead of JavaScript... well, that's thankfully easy too! 
         Though requires a few extra steps. Since couldn't find a good tutorial on
         how to get Scala.js working in a google Cloud Function, I decided to write one.
       
---

It's easy to spin up a node.js runtime on Google Cloud Platform's Cloud Functions, 
but say you want to write in Scala instead of JavaScript... well, that's thankfully easy too! 
Though requires a few extra steps.

Since couldn't find a good tutorial on
how to get Scala.js working in a google Cloud Function, I decided to write one.

### What we'll build
An earth-shatteringly simple cloud function in Scala(.js) that will respond 
to any HTTP request with a `200 OK` and a plaintext body of `Hello World`. 

This tutorial is written to be accessible to beginners, and so you 
shouldn't need any deep familiarity with scala.js, sbt, GCP, cloud functions nor node.js to follow this example.

In the end, we'll be have about 10 lines of scala code and approximately the same amount
of `sbt` configuration - that's all it takes. There's a few interesting things that
are worth paying attention to within those 20 lines, so let's get to it.

Note: The latest version of the code in this tutorial example can be 
[found on GitHub](https://github.com/TobiasRoland/scalajs-gcp-cloud-function).

### Preconditions
I assume the following have been installed already:

* sbt
* nodejs

### Tutorial

We'll start with a vanilla sbt project:

```
 hello-world
 ├── build.sbt
 └── project
     └── plugins.sbt
```

#### Add the scalajs sbt plugin:
In your `plugins.sbt`, declare that you want to use the scala.js plugin 
(latest version can be found [here](http://www.scala-js.org/doc/project/)):

```scala
addSbtPlugin("org.scala-js" % "sbt-scalajs" % "0.6.31")
```

#### Add your sbt configuration:
In your `build.sbt`, you will need to enable the plugin and set a few important settings.

```scala
name := "hello-world"
version := "0.1"
scalaVersion := "2.12.10"
enablePlugins(ScalaJSPlugin)
scalaJSModuleKind := org.scalajs.core.tools.linker.backend.ModuleKind.CommonJSModule
scalaJSUseMainModuleInitializer := false

// NOTE! To use dependencies with scala.js, dependencies are declared with triple percentage instead of double
libraryDependencies += "io.scalajs.npm" %%% "express" % "0.4.2"
```

What we've accomplished here:

**enablePlugins(ScalaJSPlugin)** does what it says on the tin


**scalaJSModuleKind** has been set to CommonJSModule. This is the module system of NodeJS (our runtime), and allows
us to export our methods so they can be invoked by GCP.

**scalaJSUseMainModuleInitializer** is set to false as we won't be using a "main app". We want to compile
all of our code into a single javascript `index.js` file and expose an exported
JS-function that can be invoked by GCP


**[express](https://github.com/scalajs-io/express) dependency**. This is the 
library we use to handle the HTTP Request and Response. 
If you've ever created 
a GCP Cloud Function from Google's tutorial on writing a 
[Slack command with GCP Functions](https://cloud.google.com/functions/docs/tutorials/slack) in JS, 
it is indeed the very same npm library wrapped in a thin shim of scala.

**Note:** At the time of writing, latest version of express is `"io.scalajs.npm" %%% "express" % "0.5"` though 
there  [appears to be an issue](https://github.com/scalajs-io/nodejs/issues/25)
with the dependency  not resolving - try the latest version out, and if you're having issues,
fall back to an earlier version.

#### HelloWorldExample.scala

Enough setup - now, let's write the actual code that will respond with `Hello World` when receiving
and http request.

Create a scala file, `src/scala/codes/mostly/gcp/cloudfunctions/HelloWorldExample.scala`, and populate it first of all with some imports:

```scala
import io.scalajs.npm.express.{Request, Response}
import scala.scalajs.js.{Function2 => JSFunction2}
import scala.scalajs.js.annotation.JSExportTopLevel
```

We will use `Response` and `Request` from the **express** dependency mentioned earlier, and 
we've also imported the [scalajs Function2](https://www.scala-js.org/doc/interoperability/types.html) as `JSFunction2`.
You strictly speaking don't have to do this renaming, but I like to make that distinction since 
the standard scala library already [has a Function2](https://www.scala-lang.org/api/current/scala/Function2.html),
and it's nice to keep the distinction between regular scala code and the 
explicitly JS-code. Lastly, we've got an import for the JSExportTopLevel annotation - we'll come to that in a bit.

We need to provide a JSFunction2 that can be called by GCP:

```scala
object HelloWorldExample {
  val helloWorld: JSFunction2[Request, Response, Unit] = (req, res) ⇒ {
    res.status(200).send("Hello World")
  }
}
```

The function itself is trivial. It's interesting to note the right-hand side of the `=`
 is just regular scala code. The code is automatically (well, implicitly) 
 converted into JSFunction2!

Finally, we need to make use of the `JSExportTopLevel` annotation:

```scala
object HelloWorldExample {
  @JSExportTopLevel("helloWorld")
  val helloWorld: JSFunction2[Request, Response, Unit] = (req, res) ⇒ {
    res.status(200).send("Hello World")
  }
}
```

Adding the annotation specifies that the function should be exported to the top level of the module, 
and will thus be callable from GCP as "helloWorld" (or whatever you
decided to put as the parameter). The string doesn't strictly *have*
to match the name of the `val`, but I see no reason not to have them be identical.

Putting it all together, we end up with:

```scala
package codes.mostly.gcp.cloudfunctions

import io.scalajs.npm.express.{Request, Response}
import scala.scalajs.js.annotation.JSExportTopLevel
import scala.scalajs.js.{Function2 => JSFunction2}

object HelloWorldExample {
  @JSExportTopLevel("helloWorld")
  val helloWorld: JSFunction2[Request, Response, Unit] = (req, res) ⇒ {
    res.status(200).send("Hello World")
  }
}
```

Exactly ten lines of scala if you ignore the whitespace.

#### Build it
OK. Since we're using the sbt scalajs plugin, we can now run a one-line command to build our JS file:

```bash
$ sbt fullOptJS
```

This will generate an optimized `.js` file in your `target` folder. If the name of your project is `hello-world`,
your file will be named `/target/scala-2.12/hello-world-opt.js`. Because we used `fullOptJS` to fully 
optimize the JS, it should've been minimized into javascript gibberish:



Looks like a nightmare at first glance, but it's actually a thing of beauty. 
You will note that despite us compiling, or rather, transpiling, scala 
into JS, the end result is surprisingly a small amount of Javascript.
This is thanks to the [optimizer](https://www.scala-js.org/doc/internals/compile-opt-pipeline.html) dutifully
identifying the classes and methods reachable 
from our entry point and removing everything else.

### Wrapping up + next steps

... And that's it! All you've got left is deploying your minimized javascript. For that, I refer you to the excellent
 GCP Cloud Functions [documentation](https://cloud.google.com/functions/docs/deploying/).

Obviously, the Hello World example is too simple to justify a transpiled scala.js project,
but for projects where you want type safety and the scala eco system present,
I think tiny amount of boilerplate and dependencies required to get up and running makes
it worthwhile.

Word of warning; as you add more dependencies and lines of code to your project, the JS payload size will
start to shoot up rather quickly, so keep an eye on your file size. 

If you found this useful, have a look at the [code on github](https://github.com/TobiasRoland/scalajs-gcp-cloud-function)
and hey while you're there, maybe add a ⭐ to give me that dopamine hit of validation!

This is just a primer; In a future post, I'll write up a more involved example based on this simple skeleton.