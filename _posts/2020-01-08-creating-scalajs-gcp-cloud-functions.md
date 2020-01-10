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

```javascript
'use strict';
'use strict';var e="object"===typeof __ScalaJSEnv&&__ScalaJSEnv?__ScalaJSEnv:{},k="object"===typeof e.global&&e.global?e.global:"object"===typeof global&&global&&global.Object===Object?global:this;e.global=k;var m=exports;e.exportsNamespace=m;k.Object.freeze(e);var q={envInfo:e,semantics:{asInstanceOfs:2,arrayIndexOutOfBounds:2,moduleInit:2,strictFloats:!1,productionMode:!0},assumingES6:!1,linkerVersion:"0.6.31",globalThis:this};k.Object.freeze(q);k.Object.freeze(q.semantics);
var r=k.Math.imul||function(a,b){var c=a&65535,d=b&65535;return c*d+((a>>>16&65535)*d+c*(b>>>16&65535)<<16>>>0)|0},t=k.Math.clz32||function(a){if(0===a)return 32;var b=1;0===(a&4294901760)&&(a<<=16,b+=16);0===(a&4278190080)&&(a<<=8,b+=8);0===(a&4026531840)&&(a<<=4,b+=4);0===(a&3221225472)&&(a<<=2,b+=2);return b+(a>>31)},u=0,v=k.WeakMap?new k.WeakMap:null;function w(a){return function(b,c){return!(!b||!b.$classData||b.$classData.k!==c||b.$classData.i!==a)}}function aa(a){for(var b in a)return b}
function x(a,b,c){var d=new a.A(b[c]);if(c<b.length-1){a=a.l;c+=1;for(var h=d.y,g=0;g<h.length;g++)h[g]=x(a,b,c)}return d}function ba(a){switch(typeof a){case "string":return y(z);case "number":var b=a|0;return b===a?A(b)?y(B):C(b)?y(D):y(E):"number"===typeof a?y(F):y(G);case "boolean":return y(I);case "undefined":return y(ca);default:return null===a?a.T():a instanceof J?y(da):a&&a.$classData?y(a.$classData):null}}
function ea(a){switch(typeof a){case "string":fa||(fa=(new K).d());for(var b=0,c=1,d=-1+(a.length|0)|0;0<=d;)b=b+r(65535&(a.charCodeAt(d)|0),c)|0,c=r(31,c),d=-1+d|0;return b;case "number":L||(L=(new M).d());b=L;c=a|0;if(c===a&&-Infinity!==1/a)b=c;else{if(b.f)b.B[0]=a,b=N(b.r[b.D]|0,b.r[b.C]|0);else{if(a!==a)b=!1,a=2047,c=+k.Math.pow(2,51);else if(Infinity===a||-Infinity===a)b=0>a,a=2047,c=0;else if(0===a)b=-Infinity===1/a,c=a=0;else if(d=(b=0>a)?-a:a,d>=+k.Math.pow(2,-1022)){a=+k.Math.pow(2,52);c=
+k.Math.log(d)/.6931471805599453;c=+k.Math.floor(c)|0;c=1023>c?c:1023;var h=+k.Math.pow(2,c);h>d&&(c=-1+c|0,h/=2);h=d/h*a;d=+k.Math.floor(h);h-=d;d=.5>h?d:.5<h?1+d:0!==d%2?1+d:d;2<=d/a&&(c=1+c|0,d=1);1023<c?(c=2047,d=0):(c=1023+c|0,d-=a);a=c;c=d}else a=d/+k.Math.pow(2,-1074),c=+k.Math.floor(a),d=a-c,a=0,c=.5>d?c:.5<d?1+c:0!==c%2?1+c:c;c=+c;b=N(c|0,(b?-2147483648:0)|(a|0)<<20|c/4294967296|0)}b=b.s^b.q}return b;case "boolean":return a?1231:1237;case "undefined":return 0;default:return a&&a.$classData||
null===a?a.w():null===v?42:ha(a)}}var ha=null!==v?function(a){switch(typeof a){case "string":case "number":case "boolean":case "undefined":return ea(a);default:if(null===a)return 0;var b=v.get(a);void 0===b&&(u=b=u+1|0,v.set(a,b));return b}}:function(a){if(a&&a.$classData){var b=a.$idHashCode$0;if(void 0!==b)return b;if(k.Object.isSealed(a))return 42;u=b=u+1|0;return a.$idHashCode$0=b}return null===a?0:ea(a)};function A(a){return"number"===typeof a&&a<<24>>24===a&&1/a!==1/-0}
function C(a){return"number"===typeof a&&a<<16>>16===a&&1/a!==1/-0}function O(){this.t=this.A=void 0;this.i=this.l=this.h=null;this.k=0;this.z=null;this.p="";this.b=this.n=this.o=void 0;this.name="";this.isRawJSType=this.isArrayClass=this.isInterface=this.isPrimitive=!1;this.isInstance=void 0}function P(a,b,c){var d=new O;d.h={};d.l=null;d.z=a;d.p=b;d.b=function(){return!1};d.name=c;d.isPrimitive=!0;d.isInstance=function(){return!1};return d}
function Q(a,b,c,d,h,g,l){var f=new O,n=aa(a);g=g||function(p){return!!(p&&p.$classData&&p.$classData.h[n])};l=l||function(p,H){return!!(p&&p.$classData&&p.$classData.k===H&&p.$classData.i.h[n])};f.t=h;f.h=c;f.p="L"+b+";";f.b=l;f.name=b;f.isInterface=!1;f.isRawJSType=!!d;f.isInstance=g;return f}
function ia(a){function b(f){if("number"===typeof f){this.y=Array(f);for(var n=0;n<f;n++)this.y[n]=h}else this.y=f}var c=new O,d=a.z,h="longZero"==d?R().u:d;b.prototype=new S;b.prototype.constructor=b;b.prototype.$classData=c;d="["+a.p;var g=a.i||a,l=a.k+1;c.A=b;c.t=ja;c.h={a:1,V:1,c:1};c.l=a;c.i=g;c.k=l;c.z=null;c.p=d;c.o=void 0;c.n=void 0;c.b=void 0;c.name=d;c.isPrimitive=!1;c.isInterface=!1;c.isArrayClass=!0;c.isInstance=function(f){return g.b(f,l)};return c}
function y(a){if(!a.o){var b=new T;b.m=a;a.o=b}return a.o}O.prototype.getFakeInstance=function(){if(this===z)return"some string";if(this===I)return!1;if(this===B||this===D||this===E||this===F||this===G)return 0;if(this===da)return R().u;if(this!==ca)return{$classData:this}};O.prototype.getSuperclass=function(){return this.t?y(this.t):null};O.prototype.getComponentType=function(){return this.l?y(this.l):null};
O.prototype.newArrayOfThisClass=function(a){for(var b=this,c=0;c<a.length;c++)b.n||(b.n=ia(b)),b=b.n;return x(b,a,0)};var ka=P(!1,"Z","boolean"),la=P(0,"C","char"),ma=P(0,"B","byte"),na=P(0,"S","short"),oa=P(0,"I","int"),pa=P("longZero","J","long"),qa=P(0,"F","float"),ra=P(0,"D","double");ka.b=w(ka);la.b=w(la);ma.b=w(ma);na.b=w(na);oa.b=w(oa);pa.b=w(pa);qa.b=w(qa);ra.b=w(ra);function U(){}function S(){}S.prototype=U.prototype;U.prototype.d=function(){return this};U.prototype.x=function(){var a=ba(this).m.name,b=(+(this.w()>>>0)).toString(16);return a+"@"+b};U.prototype.w=function(){return ha(this)};U.prototype.toString=function(){return this.x()};var ja=Q({a:0},"java.lang.Object",{a:1},void 0,void 0,function(a){return null!==a},function(a,b){if(a=a&&a.$classData){var c=a.k||0;return!(c<b)&&(c>b||!a.i.isPrimitive)}return!1});U.prototype.$classData=ja;function V(){}
V.prototype=new S;V.prototype.constructor=V;V.prototype.d=function(){W=this;sa=function(a,b){W||(W=(new V).d());b.status(200).send("Hello World")};return this};V.prototype.$classData=Q({E:0},"codes.mostly.gcp.cloudfunctions.HelloWorldExample$",{E:1,a:1});var W=void 0;function T(){this.m=null}T.prototype=new S;T.prototype.constructor=T;T.prototype.x=function(){return(this.m.isInterface?"interface ":this.m.isPrimitive?"":"class ")+this.m.name};T.prototype.$classData=Q({I:0},"java.lang.Class",{I:1,a:1});
function M(){this.f=!1;this.B=this.r=this.j=null;this.v=!1;this.D=this.C=0}M.prototype=new S;M.prototype.constructor=M;
M.prototype.d=function(){L=this;this.j=(this.f=!!(k.ArrayBuffer&&k.Int32Array&&k.Float32Array&&k.Float64Array))?new k.ArrayBuffer(8):null;this.r=this.f?new k.Int32Array(this.j,0,2):null;this.f&&new k.Float32Array(this.j,0,2);this.B=this.f?new k.Float64Array(this.j,0,1):null;if(this.f)this.r[0]=16909060,a=1===((new k.Int8Array(this.j,0,8))[0]|0);else var a=!0;this.C=(this.v=a)?0:1;this.D=this.v?1:0;return this};M.prototype.$classData=Q({O:0},"scala.scalajs.runtime.Bits$",{O:1,a:1});var L=void 0;
function K(){}K.prototype=new S;K.prototype.constructor=K;K.prototype.d=function(){return this};K.prototype.$classData=Q({R:0},"scala.scalajs.runtime.RuntimeString$",{R:1,a:1});var fa=void 0;function X(){}X.prototype=new S;X.prototype.constructor=X;function ta(){}ta.prototype=X.prototype;var ca=Q({S:0},"scala.runtime.BoxedUnit",{S:1,a:1,c:1},void 0,void 0,function(a){return void 0===a}),I=Q({G:0},"java.lang.Boolean",{G:1,a:1,c:1,e:1},void 0,void 0,function(a){return"boolean"===typeof a});
function Y(){this.u=null}Y.prototype=new S;Y.prototype.constructor=Y;Y.prototype.d=function(){Z=this;this.u=N(0,0);return this};
function ua(a,b){if(0===(-2097152&b))b=""+(4294967296*b+ +(a>>>0));else{var c=(32+t(1E9)|0)-(0!==b?t(b):32+t(a)|0)|0,d=c,h=0===(32&d)?1E9<<d:0;d=0===(32&d)?5E8>>>(31-d|0)|0|0<<d:1E9<<d;var g=a,l=b;for(a=b=0;0<=c&&0!==(-2097152&l);){var f=g,n=l,p=h,H=d;if(n===H?(-2147483648^f)>=(-2147483648^p):(-2147483648^n)>=(-2147483648^H))f=l,n=d,l=g-h|0,f=(-2147483648^l)>(-2147483648^g)?-1+(f-n|0)|0:f-n|0,g=l,l=f,32>c?b|=1<<c:a|=1<<c;c=-1+c|0;f=d>>>1|0;h=h>>>1|0|d<<31;d=f}c=l;if(0===c?-1147483648<=(-2147483648^
g):-2147483648<=(-2147483648^c))c=4294967296*l+ +(g>>>0),g=c/1E9,h=g/4294967296|0,d=b,b=g=d+(g|0)|0,a=(-2147483648^g)<(-2147483648^d)?1+(a+h|0)|0:a+h|0,g=c%1E9|0;c=""+g;b=""+(4294967296*a+ +(b>>>0))+"000000000".substring(c.length|0)+c}return b}Y.prototype.$classData=Q({Q:0},"scala.scalajs.runtime.RuntimeLong$",{Q:1,a:1,W:1,c:1});var Z=void 0;function R(){Z||(Z=(new Y).d());return Z}
var z=Q({F:0},"java.lang.String",{F:1,a:1,c:1,U:1,e:1},void 0,void 0,function(a){return"string"===typeof a}),B=Q({H:0},"java.lang.Byte",{H:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return A(a)}),G=Q({J:0},"java.lang.Double",{J:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return"number"===typeof a}),F=Q({K:0},"java.lang.Float",{K:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return"number"===typeof a}),E=Q({L:0},"java.lang.Integer",{L:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return"number"===
typeof a&&(a|0)===a&&1/a!==1/-0}),da=Q({M:0},"java.lang.Long",{M:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return a instanceof J}),D=Q({N:0},"java.lang.Short",{N:1,g:1,a:1,c:1,e:1},void 0,void 0,function(a){return C(a)});function J(){this.q=this.s=0}J.prototype=new ta;J.prototype.constructor=J;J.prototype.x=function(){R();var a=this.s,b=this.q;return b===a>>31?""+a:0>b?"-"+ua(-a|0,0!==a?~b:-b|0):ua(a,b)};function N(a,b){var c=new J;c.s=a;c.q=b;return c}J.prototype.w=function(){return this.s^this.q};
J.prototype.$classData=Q({P:0},"scala.scalajs.runtime.RuntimeLong",{P:1,g:1,a:1,c:1,e:1});var sa=null;W||(W=(new V).d());Object.defineProperty(m,"helloWorld",{get:function(){return sa},configurable:!0});
//# sourceMappingURL=hello-world-opt.js.map
```

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