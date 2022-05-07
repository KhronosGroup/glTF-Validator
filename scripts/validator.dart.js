(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q))b[q]=a[q]}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(r.__proto__&&r.__proto__.p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function setFunctionNamesIfNecessary(a){function t(){};if(typeof t.name=="string")return
for(var s=0;s<a.length;s++){var r=a[s]
var q=Object.keys(r)
for(var p=0;p<q.length;p++){var o=q[p]
var n=r[o]
if(typeof n=="function")n.name=o}}}function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){a.prototype.__proto__=b.prototype
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++)inherit(b[s],a)}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazyOld(a,b,c,d){var s=a
a[b]=s
a[c]=function(){a[c]=function(){A.yI(b)}
var r
var q=d
try{if(a[b]===s){r=a[b]=q
r=a[b]=d()}else r=a[b]}finally{if(r===q)a[b]=null
a[c]=function(){return this[b]}}return r}}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s)a[b]=d()
a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s)A.yJ(b)
a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a){a.immutable$list=Array
a.fixed$length=Array
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s)convertToFastObject(a[s])}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.oR(b)
return new s(c,this)}:function(){if(s===null)s=A.oR(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.oR(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number")h+=x
return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,lazyOld:lazyOld,updateHolder:updateHolder,convertToFastObject:convertToFastObject,setFunctionNamesIfNecessary:setFunctionNamesIfNecessary,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var A={os:function os(){},
hU(a,b,c){if(b.i("n<0>").b(a))return new A.ej(a,b.i("@<0>").G(c).i("ej<1,2>"))
return new A.ch(a,b.i("@<0>").G(c).i("ch<1,2>"))},
pO(a){return new A.fn("Field '"+A.b(a)+"' has been assigned during initialization.")},
b5(a){return new A.fI(a)},
nU(a){var s,r=a^48
if(r<=9)return r
s=a|32
if(97<=s&&s<=102)return s-87
return-1},
r7(a,b){var s=A.nU(B.a.A(a,b)),r=A.nU(B.a.A(a,b+1))
return s*16+r-(r&256)},
cX(a,b,c){if(a==null)throw A.c(new A.e1(b,c.i("e1<0>")))
return a},
ea(a,b,c,d){A.b4(b,"start")
if(c!=null){A.b4(c,"end")
if(b>c)A.a3(A.a0(b,0,c,"start",null))}return new A.e9(a,b,c,d.i("e9<0>"))},
kw(a,b,c,d){if(t.U.b(a))return new A.bi(a,b,c.i("@<0>").G(d).i("bi<1,2>"))
return new A.br(a,b,c.i("@<0>").G(d).i("br<1,2>"))},
oy(a,b,c){var s="count"
if(t.U.b(a)){A.hM(b,s)
A.b4(b,s)
return new A.d4(a,b,c.i("d4<0>"))}A.hM(b,s)
A.b4(b,s)
return new A.bs(a,b,c.i("bs<0>"))},
jp(){return new A.bR("No element")},
vj(){return new A.bR("Too few elements")},
bW:function bW(){},
dA:function dA(a,b){this.a=a
this.$ti=b},
ch:function ch(a,b){this.a=a
this.$ti=b},
ej:function ej(a,b){this.a=a
this.$ti=b},
ef:function ef(){},
bg:function bg(a,b){this.a=a
this.$ti=b},
ci:function ci(a,b){this.a=a
this.$ti=b},
hV:function hV(a,b){this.a=a
this.b=b},
fn:function fn(a){this.a=a},
fI:function fI(a){this.a=a},
d2:function d2(a){this.a=a},
o6:function o6(){},
e1:function e1(a,b){this.a=a
this.$ti=b},
n:function n(){},
aj:function aj(){},
e9:function e9(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
aq:function aq(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
br:function br(a,b,c){this.a=a
this.b=b
this.$ti=c},
bi:function bi(a,b,c){this.a=a
this.b=b
this.$ti=c},
dZ:function dZ(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
a8:function a8(a,b,c){this.a=a
this.b=b
this.$ti=c},
ed:function ed(a,b,c){this.a=a
this.b=b
this.$ti=c},
cS:function cS(a,b,c){this.a=a
this.b=b
this.$ti=c},
bs:function bs(a,b,c){this.a=a
this.b=b
this.$ti=c},
d4:function d4(a,b,c){this.a=a
this.b=b
this.$ti=c},
e7:function e7(a,b,c){this.a=a
this.b=b
this.$ti=c},
bj:function bj(a){this.$ti=a},
dE:function dE(a){this.$ti=a},
dH:function dH(){},
fV:function fV(){},
df:function df(){},
de:function de(a){this.a=a},
eG:function eG(){},
v4(){throw A.c(A.a1("Cannot modify unmodifiable Map"))},
vd(a){if(typeof a=="number")return B.C.gC(a)
if(t.fo.b(a))return a.gC(a)
if(t.dd.b(a))return A.dc(a)
return A.o7(a)},
ve(a){return new A.iK(a)},
re(a){var s,r=v.mangledGlobalNames[a]
if(r!=null)return r
s="minified:"+a
return s},
r5(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.aU.b(a)},
b(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.aZ(a)
if(typeof s!="string")throw A.c(A.eX(a,"object","toString method returned 'null'"))
return s},
dc(a){var s,r=$.pZ
if(r==null){r=Symbol("identityHashCode")
$.pZ=r}s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
q5(a,b){var s,r,q,p,o,n,m=null
if(typeof a!="string")A.a3(A.bA(a))
s=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(s==null)return m
r=s[3]
if(b==null){if(r!=null)return parseInt(a,10)
if(s[2]!=null)return parseInt(a,16)
return m}if(b<2||b>36)throw A.c(A.a0(b,2,36,"radix",m))
if(b===10&&r!=null)return parseInt(a,10)
if(b<10||r==null){q=b<=10?47+b:86+b
p=s[1]
for(o=p.length,n=0;n<o;++n)if((B.a.E(p,n)|32)>q)return m}return parseInt(a,b)},
kT(a){return A.vT(a)},
vT(a){var s,r,q,p,o
if(a instanceof A.e)return A.aH(A.al(a),null)
s=J.c4(a)
if(s===B.bQ||s===B.bX||t.ak.b(a)){r=B.a7(a)
q=r!=="Object"&&r!==""
if(q)return r
p=a.constructor
if(typeof p=="function"){o=p.name
if(typeof o=="string")q=o!=="Object"&&o!==""
else q=!1
if(q)return o}}return A.aH(A.al(a),null)},
vV(){return Date.now()},
vW(){var s,r
if($.kU!==0)return
$.kU=1000
if(typeof window=="undefined")return
s=window
if(s==null)return
r=s.performance
if(r==null)return
if(typeof r.now!="function")return
$.kU=1e6
$.e3=new A.kS(r)},
pY(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
vY(a){var s,r,q,p=A.a([],t.Y)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.cZ)(a),++r){q=a[r]
if(!A.aX(q))throw A.c(A.bA(q))
if(q<=65535)p.push(q)
else if(q<=1114111){p.push(55296+(B.c.ae(q-65536,10)&1023))
p.push(56320+(q&1023))}else throw A.c(A.bA(q))}return A.pY(p)},
vX(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.aX(q))throw A.c(A.bA(q))
if(q<0)throw A.c(A.bA(q))
if(q>65535)return A.vY(a)}return A.pY(a)},
vZ(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
P(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.c.ae(s,10)|55296)>>>0,s&1023|56320)}}throw A.c(A.a0(a,0,1114111,null,null))},
au(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
fG(a){return a.b?A.au(a).getUTCFullYear()+0:A.au(a).getFullYear()+0},
q3(a){return a.b?A.au(a).getUTCMonth()+1:A.au(a).getMonth()+1},
q_(a){return a.b?A.au(a).getUTCDate()+0:A.au(a).getDate()+0},
q0(a){return a.b?A.au(a).getUTCHours()+0:A.au(a).getHours()+0},
q2(a){return a.b?A.au(a).getUTCMinutes()+0:A.au(a).getMinutes()+0},
q4(a){return a.b?A.au(a).getUTCSeconds()+0:A.au(a).getSeconds()+0},
q1(a){return a.b?A.au(a).getUTCMilliseconds()+0:A.au(a).getMilliseconds()+0},
bN(a,b,c){var s,r,q={}
q.a=0
s=[]
r=[]
q.a=b.length
B.d.H(s,b)
q.b=""
if(c!=null&&!c.gv(c))c.K(0,new A.kR(q,r,s))
""+q.a
return J.uI(a,new A.jq(B.dA,0,s,r,0))},
vU(a,b,c){var s,r,q=c==null||c.gv(c)
if(q){s=b.length
if(s===0){if(!!a.$0)return a.$0()}else if(s===1){if(!!a.$1)return a.$1(b[0])}else if(s===2){if(!!a.$2)return a.$2(b[0],b[1])}else if(s===3){if(!!a.$3)return a.$3(b[0],b[1],b[2])}else if(s===4){if(!!a.$4)return a.$4(b[0],b[1],b[2],b[3])}else if(s===5)if(!!a.$5)return a.$5(b[0],b[1],b[2],b[3],b[4])
r=a[""+"$"+s]
if(r!=null)return r.apply(a,b)}return A.vS(a,b,c)},
vS(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=b.length,e=a.$R
if(f<e)return A.bN(a,b,c)
s=a.$D
r=s==null
q=!r?s():null
p=J.c4(a)
o=p.$C
if(typeof o=="string")o=p[o]
if(r){if(c!=null&&c.gP(c))return A.bN(a,b,c)
if(f===e)return o.apply(a,b)
return A.bN(a,b,c)}if(Array.isArray(q)){if(c!=null&&c.gP(c))return A.bN(a,b,c)
n=e+q.length
if(f>n)return A.bN(a,b,null)
if(f<n){m=q.slice(f-e)
l=A.d8(b,!0,t.z)
B.d.H(l,m)}else l=b
return o.apply(a,l)}else{if(f>e)return A.bN(a,b,c)
l=A.d8(b,!0,t.z)
k=Object.keys(q)
if(c==null)for(r=k.length,j=0;j<k.length;k.length===r||(0,A.cZ)(k),++j){i=q[k[j]]
if(B.aa===i)return A.bN(a,l,c)
l.push(i)}else{for(r=k.length,h=0,j=0;j<k.length;k.length===r||(0,A.cZ)(k),++j){g=k[j]
if(c.B(g)){++h
l.push(c.j(0,g))}else{i=q[g]
if(B.aa===i)return A.bN(a,l,c)
l.push(i)}}if(h!==c.gh(c))return A.bN(a,l,c)}return o.apply(a,l)}},
eN(a,b){var s,r="index"
if(!A.aX(b))return new A.aN(!0,b,r,null)
s=J.a9(a)
if(b<0||b>=s)return A.d6(b,a,r,null,s)
return A.w0(b,r)},
xX(a,b,c){if(a<0||a>c)return A.a0(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.a0(b,a,c,"end",null)
return new A.aN(!0,b,"end",null)},
bA(a){return new A.aN(!0,a,null,null)},
xT(a){if(typeof a!="number")throw A.c(A.bA(a))
return a},
c(a){var s,r
if(a==null)a=new A.fC()
s=new Error()
s.dartException=a
r=A.yK
if("defineProperty" in Object){Object.defineProperty(s,"message",{get:r})
s.name=""}else s.toString=r
return s},
yK(){return J.aZ(this.dartException)},
a3(a){throw A.c(a)},
cZ(a){throw A.c(A.aa(a))},
bv(a){var s,r,q,p,o,n
a=A.ra(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.a([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.ma(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
mb(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
qa(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
ot(a,b){var s=b==null,r=s?null:b.method
return new A.fl(a,r,s?null:b.receiver)},
X(a){if(a==null)return new A.fD(a)
if(a instanceof A.dF)return A.c6(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.c6(a,a.dartException)
return A.xC(a)},
c6(a,b){if(t.a.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
xC(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.c.ae(r,16)&8191)===10)switch(q){case 438:return A.c6(a,A.ot(A.b(s)+" (Error "+q+")",e))
case 445:case 5007:p=A.b(s)+" (Error "+q+")"
return A.c6(a,new A.e2(p,e))}}if(a instanceof TypeError){o=$.uh()
n=$.ui()
m=$.uj()
l=$.uk()
k=$.un()
j=$.uo()
i=$.um()
$.ul()
h=$.uq()
g=$.up()
f=o.a6(s)
if(f!=null)return A.c6(a,A.ot(s,f))
else{f=n.a6(s)
if(f!=null){f.method="call"
return A.c6(a,A.ot(s,f))}else{f=m.a6(s)
if(f==null){f=l.a6(s)
if(f==null){f=k.a6(s)
if(f==null){f=j.a6(s)
if(f==null){f=i.a6(s)
if(f==null){f=l.a6(s)
if(f==null){f=h.a6(s)
if(f==null){f=g.a6(s)
p=f!=null}else p=!0}else p=!0}else p=!0}else p=!0}else p=!0}else p=!0}else p=!0
if(p)return A.c6(a,new A.e2(s,f==null?e:f.method))}}return A.c6(a,new A.fU(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.e8()
s=function(b){try{return String(b)}catch(d){}return null}(a)
return A.c6(a,new A.aN(!1,e,e,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.e8()
return a},
aY(a){var s
if(a instanceof A.dF)return a.b
if(a==null)return new A.et(a)
s=a.$cachedTrace
if(s!=null)return s
return a.$cachedTrace=new A.et(a)},
o7(a){if(a==null||typeof a!="object")return J.d0(a)
else return A.dc(a)},
qX(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.m(0,a[s],a[r])}return b},
y0(a,b){var s,r=a.length
for(s=0;s<r;++s)b.w(0,a[s])
return b},
ya(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.c(new A.h9("Unsupported number of arguments for wrapped closure"))},
eM(a,b){var s
if(a==null)return null
s=a.$identity
if(!!s)return s
s=function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.ya)
a.$identity=s
return s},
v3(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.fN().constructor.prototype):Object.create(new A.d1(null,null).constructor.prototype)
s.$initialize=s.constructor
if(h)r=function static_tear_off(){this.$initialize()}
else r=function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.pF(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.v_(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.pF(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
v_(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.c("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.uT)}throw A.c("Error in functionType of tearoff")},
v0(a,b,c,d){var s=A.pD
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
pF(a,b,c,d){var s,r
if(c)return A.v2(a,b,d)
s=b.length
r=A.v0(s,d,a,b)
return r},
v1(a,b,c,d){var s=A.pD,r=A.uU
switch(b?-1:a){case 0:throw A.c(new A.fL("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
v2(a,b,c){var s,r,q,p=$.pB
p==null?$.pB=A.pA("interceptor"):p
s=$.pC
s==null?$.pC=A.pA("receiver"):s
r=b.length
q=A.v1(r,c,a,b)
return q},
oR(a){return A.v3(a)},
uT(a,b){return A.nh(v.typeUniverse,A.al(a.a),b)},
pD(a){return a.a},
uU(a){return a.b},
pA(a){var s,r,q,p=new A.d1("receiver","interceptor"),o=J.oq(Object.getOwnPropertyNames(p))
for(s=o.length,r=0;r<s;++r){q=o[r]
if(p[q]===a)return q}throw A.c(A.an("Field name "+a+" not found.",null))},
yI(a){throw A.c(new A.f8(a))},
r_(a){return v.getIsolateTag(a)},
Cu(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
yu(a){var s,r,q,p,o,n=$.r1.$1(a),m=$.nN[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.nY[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.qS.$2(a,n)
if(q!=null){m=$.nN[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.nY[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.o5(s)
$.nN[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.nY[n]=s
return s}if(p==="-"){o=A.o5(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.r8(a,s)
if(p==="*")throw A.c(A.qb(n))
if(v.leafTags[n]===true){o=A.o5(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.r8(a,s)},
r8(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.oU(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
o5(a){return J.oU(a,!1,null,!!a.$iae)},
yw(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.o5(s)
else return J.oU(s,c,null,null)},
y8(){if(!0===$.oT)return
$.oT=!0
A.y9()},
y9(){var s,r,q,p,o,n,m,l
$.nN=Object.create(null)
$.nY=Object.create(null)
A.y7()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.r9.$1(o)
if(n!=null){m=A.yw(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
y7(){var s,r,q,p,o,n,m=B.ba()
m=A.dw(B.bb,A.dw(B.bc,A.dw(B.a8,A.dw(B.a8,A.dw(B.bd,A.dw(B.be,A.dw(B.bf(B.a7),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(s.constructor==Array)for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.r1=new A.nV(p)
$.qS=new A.nW(o)
$.r9=new A.nX(n)},
dw(a,b){return a(b)||b},
vl(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=f?"g":"",n=function(g,h){try{return new RegExp(g,h)}catch(m){return m}}(a,s+r+q+p+o)
if(n instanceof RegExp)return n
throw A.c(A.V("Illegal RegExp pattern ("+String(n)+")",a,null))},
xY(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
ra(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
rc(a,b,c){var s=A.yG(a,b,c)
return s},
yG(a,b,c){var s,r,q,p
if(b===""){if(a==="")return c
s=a.length
for(r=c,q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}p=a.indexOf(b,0)
if(p<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.ra(b),"g"),A.xY(c))},
dB:function dB(a,b){this.a=a
this.$ti=b},
d3:function d3(){},
aA:function aA(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
eh:function eh(a,b){this.a=a
this.$ti=b},
a5:function a5(a,b){this.a=a
this.$ti=b},
iK:function iK(a){this.a=a},
jq:function jq(a,b,c,d,e){var _=this
_.a=a
_.c=b
_.d=c
_.e=d
_.f=e},
kS:function kS(a){this.a=a},
kR:function kR(a,b,c){this.a=a
this.b=b
this.c=c},
ma:function ma(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
e2:function e2(a,b){this.a=a
this.b=b},
fl:function fl(a,b,c){this.a=a
this.b=b
this.c=c},
fU:function fU(a){this.a=a},
fD:function fD(a){this.a=a},
dF:function dF(a,b){this.a=a
this.b=b},
et:function et(a){this.a=a
this.b=null},
cj:function cj(){},
f2:function f2(){},
f3:function f3(){},
fQ:function fQ(){},
fN:function fN(){},
d1:function d1(a,b){this.a=a
this.b=b},
fL:function fL(a){this.a=a},
n9:function n9(){},
aD:function aD(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
jw:function jw(a){this.a=a},
kr:function kr(a,b){this.a=a
this.b=b
this.c=null},
dU:function dU(a,b){this.a=a
this.$ti=b},
dV:function dV(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
nV:function nV(a){this.a=a},
nW:function nW(a){this.a=a},
nX:function nX(a){this.a=a},
jr:function jr(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
n7:function n7(a){this.b=a},
ds(a,b,c){if(!A.aX(b))throw A.c(A.an("Invalid view offsetInBytes "+A.b(b),null))},
x4(a){return a},
kI(a,b,c){A.ds(a,b,c)
return c==null?new DataView(a,b):new DataView(a,b,c)},
vL(a){return new Float32Array(a)},
vM(a){return new Int8Array(a)},
pV(a,b,c){A.ds(a,b,c)
return new Uint16Array(a,b,c)},
pW(a,b,c){A.ds(a,b,c)
return new Uint32Array(a,b,c)},
vN(a){return new Uint8Array(a)},
kJ(a,b,c){A.ds(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bz(a,b,c){if(a>>>0!==a||a>=c)throw A.c(A.eN(b,a))},
c1(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.c(A.xX(a,b,c))
return b},
ft:function ft(){},
cK:function cK(){},
db:function db(){},
e_:function e_(){},
aF:function aF(){},
fu:function fu(){},
fv:function fv(){},
fw:function fw(){},
fx:function fx(){},
fy:function fy(){},
fz:function fz(){},
fA:function fA(){},
e0:function e0(){},
cL:function cL(){},
eo:function eo(){},
ep:function ep(){},
eq:function eq(){},
er:function er(){},
w2(a,b){var s=b.c
return s==null?b.c=A.oE(a,b.z,!0):s},
q6(a,b){var s=b.c
return s==null?b.c=A.eA(a,"aB",[b.z]):s},
q7(a){var s=a.y
if(s===6||s===7||s===8)return A.q7(a.z)
return s===11||s===12},
w1(a){return a.cy},
aM(a){return A.ho(v.typeUniverse,a,!1)},
c3(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=b.y
switch(c){case 5:case 1:case 2:case 3:case 4:return b
case 6:s=b.z
r=A.c3(a,s,a0,a1)
if(r===s)return b
return A.qr(a,r,!0)
case 7:s=b.z
r=A.c3(a,s,a0,a1)
if(r===s)return b
return A.oE(a,r,!0)
case 8:s=b.z
r=A.c3(a,s,a0,a1)
if(r===s)return b
return A.qq(a,r,!0)
case 9:q=b.Q
p=A.eL(a,q,a0,a1)
if(p===q)return b
return A.eA(a,b.z,p)
case 10:o=b.z
n=A.c3(a,o,a0,a1)
m=b.Q
l=A.eL(a,m,a0,a1)
if(n===o&&l===m)return b
return A.oC(a,n,l)
case 11:k=b.z
j=A.c3(a,k,a0,a1)
i=b.Q
h=A.xz(a,i,a0,a1)
if(j===k&&h===i)return b
return A.qp(a,j,h)
case 12:g=b.Q
a1+=g.length
f=A.eL(a,g,a0,a1)
o=b.z
n=A.c3(a,o,a0,a1)
if(f===g&&n===o)return b
return A.oD(a,n,f,!0)
case 13:e=b.z
if(e<a1)return b
d=a0[e-a1]
if(d==null)return b
return d
default:throw A.c(A.hN("Attempted to substitute unexpected RTI kind "+c))}},
eL(a,b,c,d){var s,r,q,p,o=b.length,n=A.nj(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.c3(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
xA(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.nj(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.c3(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
xz(a,b,c,d){var s,r=b.a,q=A.eL(a,r,c,d),p=b.b,o=A.eL(a,p,c,d),n=b.c,m=A.xA(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.hc()
s.a=q
s.b=o
s.c=m
return s},
a(a,b){a[v.arrayRti]=b
return a},
xU(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.y5(s)
return a.$S()}return null},
r3(a,b){var s
if(A.q7(b))if(a instanceof A.cj){s=A.xU(a)
if(s!=null)return s}return A.al(a)},
al(a){var s
if(a instanceof A.e){s=a.$ti
return s!=null?s:A.oM(a)}if(Array.isArray(a))return A.a2(a)
return A.oM(J.c4(a))},
a2(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
D(a){var s=a.$ti
return s!=null?s:A.oM(a)},
oM(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.xc(a,s)},
xc(a,b){var s=a instanceof A.cj?a.__proto__.__proto__.constructor:b,r=A.wE(v.typeUniverse,s.name)
b.$ccache=r
return r},
y5(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.ho(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
qV(a){var s,r,q,p=a.x
if(p!=null)return p
s=a.cy
r=s.replace(/\*/g,"")
if(r===s)return a.x=new A.ey(a)
q=A.ho(v.typeUniverse,r,!0)
p=q.x
return a.x=p==null?q.x=new A.ey(q):p},
x(a){return A.qV(A.ho(v.typeUniverse,a,!1))},
xb(a){var s,r,q,p=this,o=t.K
if(p===o)return A.dt(p,a,A.xg)
if(!A.bB(p))if(!(p===t._))o=p===o
else o=!0
else o=!0
if(o)return A.dt(p,a,A.xj)
o=p.y
s=o===6?p.z:p
if(s===t.S)r=A.aX
else if(s===t.gR||s===t.di)r=A.xf
else if(s===t.R)r=A.xh
else r=s===t.y?A.nD:null
if(r!=null)return A.dt(p,a,r)
if(s.y===9){q=s.z
if(s.Q.every(A.yb)){p.r="$i"+q
if(q==="q")return A.dt(p,a,A.xe)
return A.dt(p,a,A.xi)}}else if(o===7)return A.dt(p,a,A.x7)
return A.dt(p,a,A.x5)},
dt(a,b,c){a.b=c
return a.b(b)},
xa(a){var s,r,q=this
if(!A.bB(q))if(!(q===t._))s=q===t.K
else s=!0
else s=!0
if(s)r=A.wY
else if(q===t.K)r=A.wX
else r=A.x6
q.a=r
return q.a(a)},
nE(a){var s,r=a.y
if(!A.bB(a))if(!(a===t._))if(!(a===t.I))if(r!==7)s=r===8&&A.nE(a.z)||a===t.P||a===t.T
else s=!0
else s=!0
else s=!0
else s=!0
return s},
x5(a){var s=this
if(a==null)return A.nE(s)
return A.af(v.typeUniverse,A.r3(a,s),null,s,null)},
x7(a){if(a==null)return!0
return this.z.b(a)},
xi(a){var s,r=this
if(a==null)return A.nE(r)
s=r.r
if(a instanceof A.e)return!!a[s]
return!!J.c4(a)[s]},
xe(a){var s,r=this
if(a==null)return A.nE(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.r
if(a instanceof A.e)return!!a[s]
return!!J.c4(a)[s]},
Ch(a){var s=this
if(a==null)return a
else if(s.b(a))return a
A.qC(a,s)},
x6(a){var s=this
if(a==null)return a
else if(s.b(a))return a
A.qC(a,s)},
qC(a,b){throw A.c(A.wu(A.ql(a,A.r3(a,b),A.aH(b,null))))},
ql(a,b,c){var s=A.cl(a),r=A.aH(b==null?A.al(a):b,null)
return s+": type '"+A.b(r)+"' is not a subtype of type '"+A.b(c)+"'"},
wu(a){return new A.ez("TypeError: "+a)},
ay(a,b){return new A.ez("TypeError: "+A.ql(a,null,b))},
xg(a){return a!=null},
wX(a){return a},
xj(a){return!0},
wY(a){return a},
nD(a){return!0===a||!1===a},
BZ(a){if(!0===a)return!0
if(!1===a)return!1
throw A.c(A.ay(a,"bool"))},
C0(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.c(A.ay(a,"bool"))},
C_(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.c(A.ay(a,"bool?"))},
C1(a){if(typeof a=="number")return a
throw A.c(A.ay(a,"double"))},
C3(a){if(typeof a=="number")return a
if(a==null)return a
throw A.c(A.ay(a,"double"))},
C2(a){if(typeof a=="number")return a
if(a==null)return a
throw A.c(A.ay(a,"double?"))},
aX(a){return typeof a=="number"&&Math.floor(a)===a},
C4(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.c(A.ay(a,"int"))},
C6(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.c(A.ay(a,"int"))},
C5(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.c(A.ay(a,"int?"))},
xf(a){return typeof a=="number"},
C7(a){if(typeof a=="number")return a
throw A.c(A.ay(a,"num"))},
C9(a){if(typeof a=="number")return a
if(a==null)return a
throw A.c(A.ay(a,"num"))},
C8(a){if(typeof a=="number")return a
if(a==null)return a
throw A.c(A.ay(a,"num?"))},
xh(a){return typeof a=="string"},
Ca(a){if(typeof a=="string")return a
throw A.c(A.ay(a,"String"))},
Cc(a){if(typeof a=="string")return a
if(a==null)return a
throw A.c(A.ay(a,"String"))},
Cb(a){if(typeof a=="string")return a
if(a==null)return a
throw A.c(A.ay(a,"String?"))},
xv(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=B.a.al(r,A.aH(a[q],b))
return s},
qE(a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=", "
if(a6!=null){s=a6.length
if(a5==null){a5=A.a([],t.s)
r=null}else r=a5.length
q=a5.length
for(p=s;p>0;--p)a5.push("T"+(q+p))
for(o=t.O,n=t._,m=t.K,l="<",k="",p=0;p<s;++p,k=a3){l=B.a.al(l+k,a5[a5.length-1-p])
j=a6[p]
i=j.y
if(!(i===2||i===3||i===4||i===5||j===o))if(!(j===n))h=j===m
else h=!0
else h=!0
if(!h)l+=B.a.al(" extends ",A.aH(j,a5))}l+=">"}else{l=""
r=null}o=a4.z
g=a4.Q
f=g.a
e=f.length
d=g.b
c=d.length
b=g.c
a=b.length
a0=A.aH(o,a5)
for(a1="",a2="",p=0;p<e;++p,a2=a3)a1+=B.a.al(a2,A.aH(f[p],a5))
if(c>0){a1+=a2+"["
for(a2="",p=0;p<c;++p,a2=a3)a1+=B.a.al(a2,A.aH(d[p],a5))
a1+="]"}if(a>0){a1+=a2+"{"
for(a2="",p=0;p<a;p+=3,a2=a3){a1+=a2
if(b[p+1])a1+="required "
a1+=J.pr(A.aH(b[p+2],a5)," ")+b[p]}a1+="}"}if(r!=null){a5.toString
a5.length=r}return l+"("+a1+") => "+A.b(a0)},
aH(a,b){var s,r,q,p,o,n,m=a.y
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=A.aH(a.z,b)
return s}if(m===7){r=a.z
s=A.aH(r,b)
q=r.y
return J.pr(q===11||q===12?B.a.al("(",s)+")":s,"?")}if(m===8)return"FutureOr<"+A.b(A.aH(a.z,b))+">"
if(m===9){p=A.xB(a.z)
o=a.Q
return o.length>0?p+("<"+A.xv(o,b)+">"):p}if(m===11)return A.qE(a,b,null)
if(m===12)return A.qE(a.z,b,a.Q)
if(m===13){b.toString
n=a.z
return b[b.length-1-n]}return"?"},
xB(a){var s,r=v.mangledGlobalNames[a]
if(r!=null)return r
s="minified:"+a
return s},
wF(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
wE(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.ho(a,b,!1)
else if(typeof m=="number"){s=m
r=A.eB(a,5,"#")
q=A.nj(s)
for(p=0;p<s;++p)q[p]=r
o=A.eA(a,b,q)
n[b]=o
return o}else return m},
wC(a,b){return A.qA(a.tR,b)},
wB(a,b){return A.qA(a.eT,b)},
ho(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.qo(A.qm(a,null,b,c))
r.set(b,s)
return s},
nh(a,b,c){var s,r,q=b.ch
if(q==null)q=b.ch=new Map()
s=q.get(c)
if(s!=null)return s
r=A.qo(A.qm(a,b,c,!0))
q.set(c,r)
return r},
wD(a,b,c){var s,r,q,p=b.cx
if(p==null)p=b.cx=new Map()
s=c.cy
r=p.get(s)
if(r!=null)return r
q=A.oC(a,b,c.y===10?c.Q:[c])
p.set(s,q)
return q},
c0(a,b){b.a=A.xa
b.b=A.xb
return b},
eB(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.aT(null,null)
s.y=b
s.cy=c
r=A.c0(a,s)
a.eC.set(c,r)
return r},
qr(a,b,c){var s,r=b.cy+"*",q=a.eC.get(r)
if(q!=null)return q
s=A.wz(a,b,r,c)
a.eC.set(r,s)
return s},
wz(a,b,c,d){var s,r,q
if(d){s=b.y
if(!A.bB(b))r=b===t.P||b===t.T||s===7||s===6
else r=!0
if(r)return b}q=new A.aT(null,null)
q.y=6
q.z=b
q.cy=c
return A.c0(a,q)},
oE(a,b,c){var s,r=b.cy+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.wy(a,b,r,c)
a.eC.set(r,s)
return s},
wy(a,b,c,d){var s,r,q,p
if(d){s=b.y
if(!A.bB(b))if(!(b===t.P||b===t.T))if(s!==7)r=s===8&&A.nZ(b.z)
else r=!0
else r=!0
else r=!0
if(r)return b
else if(s===1||b===t.I)return t.P
else if(s===6){q=b.z
if(q.y===8&&A.nZ(q.z))return q
else return A.w2(a,b)}}p=new A.aT(null,null)
p.y=7
p.z=b
p.cy=c
return A.c0(a,p)},
qq(a,b,c){var s,r=b.cy+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.ww(a,b,r,c)
a.eC.set(r,s)
return s},
ww(a,b,c,d){var s,r,q
if(d){s=b.y
if(!A.bB(b))if(!(b===t._))r=b===t.K
else r=!0
else r=!0
if(r||b===t.K)return b
else if(s===1)return A.eA(a,"aB",[b])
else if(b===t.P||b===t.T)return t.eH}q=new A.aT(null,null)
q.y=8
q.z=b
q.cy=c
return A.c0(a,q)},
wA(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.aT(null,null)
s.y=13
s.z=b
s.cy=q
r=A.c0(a,s)
a.eC.set(q,r)
return r},
hn(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].cy
return s},
wv(a){var s,r,q,p,o,n,m=a.length
for(s="",r="",q=0;q<m;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
n=a[q+2].cy
s+=r+p+o+n}return s},
eA(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.hn(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.aT(null,null)
r.y=9
r.z=b
r.Q=c
if(c.length>0)r.c=c[0]
r.cy=p
q=A.c0(a,r)
a.eC.set(p,q)
return q},
oC(a,b,c){var s,r,q,p,o,n
if(b.y===10){s=b.z
r=b.Q.concat(c)}else{r=c
s=b}q=s.cy+(";<"+A.hn(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.aT(null,null)
o.y=10
o.z=s
o.Q=r
o.cy=q
n=A.c0(a,o)
a.eC.set(q,n)
return n},
qp(a,b,c){var s,r,q,p,o,n=b.cy,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.hn(m)
if(j>0){s=l>0?",":""
r=A.hn(k)
g+=s+"["+r+"]"}if(h>0){s=l>0?",":""
r=A.wv(i)
g+=s+"{"+r+"}"}q=n+(g+")")
p=a.eC.get(q)
if(p!=null)return p
o=new A.aT(null,null)
o.y=11
o.z=b
o.Q=c
o.cy=q
r=A.c0(a,o)
a.eC.set(q,r)
return r},
oD(a,b,c,d){var s,r=b.cy+("<"+A.hn(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.wx(a,b,c,r,d)
a.eC.set(r,s)
return s},
wx(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.nj(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.y===1){r[p]=o;++q}}if(q>0){n=A.c3(a,b,r,0)
m=A.eL(a,c,r,0)
return A.oD(a,n,m,c!==m)}}l=new A.aT(null,null)
l.y=12
l.z=b
l.Q=c
l.cy=d
return A.c0(a,l)},
qm(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
qo(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=a.r,f=a.s
for(s=g.length,r=0;r<s;){q=g.charCodeAt(r)
if(q>=48&&q<=57)r=A.wp(r+1,q,g,f)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36)r=A.qn(a,r,g,f,!1)
else if(q===46)r=A.qn(a,r,g,f,!0)
else{++r
switch(q){case 44:break
case 58:f.push(!1)
break
case 33:f.push(!0)
break
case 59:f.push(A.c_(a.u,a.e,f.pop()))
break
case 94:f.push(A.wA(a.u,f.pop()))
break
case 35:f.push(A.eB(a.u,5,"#"))
break
case 64:f.push(A.eB(a.u,2,"@"))
break
case 126:f.push(A.eB(a.u,3,"~"))
break
case 60:f.push(a.p)
a.p=f.length
break
case 62:p=a.u
o=f.splice(a.p)
A.oB(a.u,a.e,o)
a.p=f.pop()
n=f.pop()
if(typeof n=="string")f.push(A.eA(p,n,o))
else{m=A.c_(p,a.e,n)
switch(m.y){case 11:f.push(A.oD(p,m,o,a.n))
break
default:f.push(A.oC(p,m,o))
break}}break
case 38:A.wq(a,f)
break
case 42:l=a.u
f.push(A.qr(l,A.c_(l,a.e,f.pop()),a.n))
break
case 63:l=a.u
f.push(A.oE(l,A.c_(l,a.e,f.pop()),a.n))
break
case 47:l=a.u
f.push(A.qq(l,A.c_(l,a.e,f.pop()),a.n))
break
case 40:f.push(a.p)
a.p=f.length
break
case 41:p=a.u
k=new A.hc()
j=p.sEA
i=p.sEA
n=f.pop()
if(typeof n=="number")switch(n){case-1:j=f.pop()
break
case-2:i=f.pop()
break
default:f.push(n)
break}else f.push(n)
o=f.splice(a.p)
A.oB(a.u,a.e,o)
a.p=f.pop()
k.a=o
k.b=j
k.c=i
f.push(A.qp(p,A.c_(p,a.e,f.pop()),k))
break
case 91:f.push(a.p)
a.p=f.length
break
case 93:o=f.splice(a.p)
A.oB(a.u,a.e,o)
a.p=f.pop()
f.push(o)
f.push(-1)
break
case 123:f.push(a.p)
a.p=f.length
break
case 125:o=f.splice(a.p)
A.ws(a.u,a.e,o)
a.p=f.pop()
f.push(o)
f.push(-2)
break
default:throw"Bad character "+q}}}h=f.pop()
return A.c_(a.u,a.e,h)},
wp(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
qn(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.y===10)o=o.z
n=A.wF(s,o.z)[p]
if(n==null)A.a3('No "'+p+'" in "'+A.w1(o)+'"')
d.push(A.nh(s,o,n))}else d.push(p)
return m},
wq(a,b){var s=b.pop()
if(0===s){b.push(A.eB(a.u,1,"0&"))
return}if(1===s){b.push(A.eB(a.u,4,"1&"))
return}throw A.c(A.hN("Unexpected extended operation "+A.b(s)))},
c_(a,b,c){if(typeof c=="string")return A.eA(a,c,a.sEA)
else if(typeof c=="number")return A.wr(a,b,c)
else return c},
oB(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.c_(a,b,c[s])},
ws(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.c_(a,b,c[s])},
wr(a,b,c){var s,r,q=b.y
if(q===10){if(c===0)return b.z
s=b.Q
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.z
q=b.y}else if(c===0)return b
if(q!==9)throw A.c(A.hN("Indexed base must be an interface type"))
s=b.Q
if(c<=s.length)return s[c-1]
throw A.c(A.hN("Bad index "+c+" for "+b.k(0)))},
af(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j
if(b===d)return!0
if(!A.bB(d))if(!(d===t._))s=d===t.K
else s=!0
else s=!0
if(s)return!0
r=b.y
if(r===4)return!0
if(A.bB(b))return!1
if(b.y!==1)s=b===t.P||b===t.T
else s=!0
if(s)return!0
q=r===13
if(q)if(A.af(a,c[b.z],c,d,e))return!0
p=d.y
if(r===6)return A.af(a,b.z,c,d,e)
if(p===6){s=d.z
return A.af(a,b,c,s,e)}if(r===8){if(!A.af(a,b.z,c,d,e))return!1
return A.af(a,A.q6(a,b),c,d,e)}if(r===7){s=A.af(a,b.z,c,d,e)
return s}if(p===8){if(A.af(a,b,c,d.z,e))return!0
return A.af(a,b,c,A.q6(a,d),e)}if(p===7){s=A.af(a,b,c,d.z,e)
return s}if(q)return!1
s=r!==11
if((!s||r===12)&&d===t.k)return!0
if(p===12){if(b===t.g)return!0
if(r!==12)return!1
o=b.Q
n=d.Q
m=o.length
if(m!==n.length)return!1
c=c==null?o:o.concat(c)
e=e==null?n:n.concat(e)
for(l=0;l<m;++l){k=o[l]
j=n[l]
if(!A.af(a,k,c,j,e)||!A.af(a,j,e,k,c))return!1}return A.qI(a,b.z,c,d.z,e)}if(p===11){if(b===t.g)return!0
if(s)return!1
return A.qI(a,b,c,d,e)}if(r===9){if(p!==9)return!1
return A.xd(a,b,c,d,e)}return!1},
qI(a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
if(!A.af(a2,a3.z,a4,a5.z,a6))return!1
s=a3.Q
r=a5.Q
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.af(a2,p[h],a6,g,a4))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.af(a2,p[o+h],a6,g,a4))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.af(a2,k[h],a6,g,a4))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;!0;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
if(a1<a0)continue
g=f[b-1]
if(!A.af(a2,e[a+2],a6,g,a4))return!1
break}}return!0},
xd(a,b,c,d,e){var s,r,q,p,o,n,m,l=b.z,k=d.z
for(;l!==k;){s=a.tR[l]
if(s==null)return!1
if(typeof s=="string"){l=s
continue}r=s[k]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.nh(a,b,r[o])
return A.qB(a,p,null,c,d.Q,e)}n=b.Q
m=d.Q
return A.qB(a,n,null,c,m,e)},
qB(a,b,c,d,e,f){var s,r,q,p=b.length
for(s=0;s<p;++s){r=b[s]
q=e[s]
if(!A.af(a,r,d,q,f))return!1}return!0},
nZ(a){var s,r=a.y
if(!(a===t.P||a===t.T))if(!A.bB(a))if(r!==7)if(!(r===6&&A.nZ(a.z)))s=r===8&&A.nZ(a.z)
else s=!0
else s=!0
else s=!0
else s=!0
return s},
yb(a){var s
if(!A.bB(a))if(!(a===t._))s=a===t.K
else s=!0
else s=!0
return s},
bB(a){var s=a.y
return s===2||s===3||s===4||s===5||a===t.O},
qA(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
nj(a){return a>0?new Array(a):v.typeUniverse.sEA},
aT:function aT(a,b){var _=this
_.a=a
_.b=b
_.x=_.r=_.c=null
_.y=0
_.cy=_.cx=_.ch=_.Q=_.z=null},
hc:function hc(){this.c=this.b=this.a=null},
ey:function ey(a){this.a=a},
h7:function h7(){},
ez:function ez(a){this.a=a},
wd(){var s,r,q={}
if(self.scheduleImmediate!=null)return A.xK()
if(self.MutationObserver!=null&&self.document!=null){s=self.document.createElement("div")
r=self.document.createElement("span")
q.a=null
new self.MutationObserver(A.eM(new A.mB(q),1)).observe(s,{childList:true})
return new A.mA(q,s,r)}else if(self.setImmediate!=null)return A.xL()
return A.xM()},
we(a){self.scheduleImmediate(A.eM(new A.mC(a),0))},
wf(a){self.setImmediate(A.eM(new A.mD(a),0))},
wg(a){A.wt(0,a)},
wt(a,b){var s=new A.nf()
s.dE(a,b)
return s},
hA(a){return new A.h_(new A.I($.F,a.i("I<0>")),a.i("h_<0>"))},
hx(a,b){a.$2(0,null)
b.b=!0
return b.a},
dr(a,b){A.wZ(a,b)},
hw(a,b){b.ai(0,a)},
hv(a,b){b.bI(A.X(a),A.aY(a))},
wZ(a,b){var s,r,q=new A.nl(b),p=new A.nm(b)
if(a instanceof A.I)a.cB(q,p,t.z)
else{s=t.z
if(t.d.b(a))a.be(q,p,s)
else{r=new A.I($.F,t.eI)
r.a=8
r.c=a
r.cB(q,p,s)}}},
hC(a){var s=function(b,c){return function(d,e){while(true)try{b(d,e)
break}catch(r){e=r
d=c}}}(a,1)
return $.F.bV(new A.nJ(s))},
mX(a){return new A.dl(a,1)},
bY(){return B.ea},
bZ(a){return new A.dl(a,3)},
c2(a,b){return new A.ex(a,b.i("ex<0>"))},
hO(a,b){var s=A.cX(a,"error",t.K)
return new A.eZ(s,b==null?A.hP(a):b)},
hP(a){var s
if(t.a.b(a)){s=a.gaT()
if(s!=null)return s}return B.bk},
mN(a,b){var s,r
for(;s=a.a,(s&4)!==0;)a=a.c
if((s&24)!==0){r=b.b0()
b.bq(a)
A.dk(b,r)}else{r=b.c
b.a=b.a&1|4
b.c=a
a.ct(r)}},
dk(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f={},e=f.a=a
for(s=t.d;!0;){r={}
q=e.a
p=(q&16)===0
o=!p
if(b==null){if(o&&(q&1)===0){e=e.c
A.hB(e.a,e.b)}return}r.a=b
n=b.a
for(e=b;n!=null;e=n,n=m){e.a=null
A.dk(f.a,e)
r.a=n
m=n.a}q=f.a
l=q.c
r.b=o
r.c=l
if(p){k=e.c
k=(k&1)!==0||(k&15)===8}else k=!0
if(k){j=e.b.b
if(o){q=q.b===j
q=!(q||q)}else q=!1
if(q){A.hB(l.a,l.b)
return}i=$.F
if(i!==j)$.F=j
else i=null
e=e.c
if((e&15)===8)new A.mV(r,f,o).$0()
else if(p){if((e&1)!==0)new A.mU(r,l).$0()}else if((e&2)!==0)new A.mT(f,r).$0()
if(i!=null)$.F=i
e=r.c
if(s.b(e)){q=r.a.$ti
q=q.i("aB<2>").b(e)||!q.Q[1].b(e)}else q=!1
if(q){h=r.a.b
if(e instanceof A.I)if((e.a&24)!==0){g=h.c
h.c=null
b=h.b1(g)
h.a=e.a&30|h.a&1
h.c=e.c
f.a=e
continue}else A.mN(e,h)
else h.bo(e)
return}}h=r.a.b
g=h.c
h.c=null
b=h.b1(g)
e=r.b
q=r.c
if(!e){h.a=8
h.c=q}else{h.a=h.a&1|16
h.c=q}f.a=h
e=h}},
xt(a,b){if(t.C.b(a))return b.bV(a)
if(t.v.b(a))return a
throw A.c(A.eX(a,"onError",u.c))},
xo(){var s,r
for(s=$.du;s!=null;s=$.du){$.eK=null
r=s.b
$.du=r
if(r==null)$.eJ=null
s.a.$0()}},
xx(){$.oN=!0
try{A.xo()}finally{$.eK=null
$.oN=!1
if($.du!=null)$.pj().$1(A.qT())}},
qN(a){var s=new A.h0(a),r=$.eJ
if(r==null){$.du=$.eJ=s
if(!$.oN)$.pj().$1(A.qT())}else $.eJ=r.b=s},
xw(a){var s,r,q,p=$.du
if(p==null){A.qN(a)
$.eK=$.eJ
return}s=new A.h0(a)
r=$.eK
if(r==null){s.b=p
$.du=$.eK=s}else{q=r.b
s.b=q
$.eK=r.b=s
if(q==null)$.eJ=s}},
rb(a){var s=null,r=$.F
if(B.i===r){A.dv(s,s,B.i,a)
return}A.dv(s,s,r,r.cF(a))},
q8(a,b){var s=null,r=b.i("b8<0>"),q=new A.b8(s,s,s,s,r)
q.c8(a)
q.cf()
return new A.b9(q,r.i("b9<1>"))},
BG(a){A.cX(a,"stream",t.K)
return new A.hl()},
w6(a,b){return new A.b8(null,null,null,a,b.i("b8<0>"))},
oP(a){var s,r,q
if(a==null)return
try{a.$0()}catch(q){s=A.X(q)
r=A.aY(q)
A.hB(s,r)}},
qk(a,b){return b==null?A.xN():b},
wk(a,b){if(t.da.b(b))return a.bV(b)
if(t.d5.b(b))return b
throw A.c(A.an("handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",null))},
xp(a){},
x0(a,b,c){var s=a.J()
if(s!=null&&s!==$.hF())s.bg(new A.nn(b,c))
else b.bs(c)},
hB(a,b){A.xw(new A.nF(a,b))},
qK(a,b,c,d){var s,r=$.F
if(r===c)return d.$0()
$.F=c
s=r
try{r=d.$0()
return r}finally{$.F=s}},
qL(a,b,c,d,e){var s,r=$.F
if(r===c)return d.$1(e)
$.F=c
s=r
try{r=d.$1(e)
return r}finally{$.F=s}},
xu(a,b,c,d,e,f){var s,r=$.F
if(r===c)return d.$2(e,f)
$.F=c
s=r
try{r=d.$2(e,f)
return r}finally{$.F=s}},
dv(a,b,c,d){if(B.i!==c)d=c.cF(d)
A.qN(d)},
mB:function mB(a){this.a=a},
mA:function mA(a,b,c){this.a=a
this.b=b
this.c=c},
mC:function mC(a){this.a=a},
mD:function mD(a){this.a=a},
nf:function nf(){},
ng:function ng(a,b){this.a=a
this.b=b},
h_:function h_(a,b){this.a=a
this.b=!1
this.$ti=b},
nl:function nl(a){this.a=a},
nm:function nm(a){this.a=a},
nJ:function nJ(a){this.a=a},
dl:function dl(a,b){this.a=a
this.b=b},
aL:function aL(a,b){var _=this
_.a=a
_.d=_.c=_.b=null
_.$ti=b},
ex:function ex(a,b){this.a=a
this.$ti=b},
eZ:function eZ(a,b){this.a=a
this.b=b},
h2:function h2(){},
by:function by(a,b){this.a=a
this.$ti=b},
bX:function bX(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
I:function I(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
mK:function mK(a,b){this.a=a
this.b=b},
mS:function mS(a,b){this.a=a
this.b=b},
mO:function mO(a){this.a=a},
mP:function mP(a){this.a=a},
mQ:function mQ(a,b,c){this.a=a
this.b=b
this.c=c},
mM:function mM(a,b){this.a=a
this.b=b},
mR:function mR(a,b){this.a=a
this.b=b},
mL:function mL(a,b,c){this.a=a
this.b=b
this.c=c},
mV:function mV(a,b,c){this.a=a
this.b=b
this.c=c},
mW:function mW(a){this.a=a},
mU:function mU(a,b){this.a=a
this.b=b},
mT:function mT(a,b){this.a=a
this.b=b},
h0:function h0(a){this.a=a
this.b=null},
aV:function aV(){},
m6:function m6(a,b){this.a=a
this.b=b},
m7:function m7(a,b){this.a=a
this.b=b},
m4:function m4(a){this.a=a},
m5:function m5(a,b,c){this.a=a
this.b=b
this.c=c},
fO:function fO(){},
fP:function fP(){},
hk:function hk(){},
ne:function ne(a){this.a=a},
nd:function nd(a){this.a=a},
h1:function h1(){},
b8:function b8(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
b9:function b9(a,b){this.a=a
this.$ti=b},
ei:function ei(a,b,c,d,e){var _=this
_.x=a
_.a=b
_.c=c
_.d=d
_.e=e
_.r=_.f=null},
ee:function ee(){},
mF:function mF(a){this.a=a},
eu:function eu(){},
h5:function h5(){},
dj:function dj(a){this.b=a
this.a=null},
mG:function mG(){},
hh:function hh(){},
n8:function n8(a,b){this.a=a
this.b=b},
ev:function ev(){this.c=this.b=null
this.a=0},
hl:function hl(){},
nn:function nn(a,b){this.a=a
this.b=b},
nk:function nk(){},
nF:function nF(a,b){this.a=a
this.b=b},
na:function na(){},
nb:function nb(a,b){this.a=a
this.b=b},
nc:function nc(a,b,c){this.a=a
this.b=b
this.c=c},
vE(a,b,c,d){return A.wn(A.xV(),a,b,c,d)},
ou(a,b,c){return A.qX(a,new A.aD(b.i("@<0>").G(c).i("aD<1,2>")))},
ai(a,b){return new A.aD(a.i("@<0>").G(b).i("aD<1,2>"))},
wn(a,b,c,d,e){var s=c!=null?c:new A.n4(d)
return new A.el(a,b,s,d.i("@<0>").G(e).i("el<1,2>"))},
ks(a){return new A.ba(a.i("ba<0>"))},
aQ(a){return new A.ba(a.i("ba<0>"))},
aR(a,b){return A.y0(a,new A.ba(b.i("ba<0>")))},
oA(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
wo(a,b,c){var s=new A.cV(a,b,c.i("cV<0>"))
s.c=a.e
return s},
x2(a,b){return J.am(a,b)},
vi(a,b,c){var s,r
if(A.oO(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.a([],t.s)
$.cW.push(a)
try{A.xk(a,s)}finally{$.cW.pop()}r=A.oz(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
jo(a,b,c){var s,r
if(A.oO(a))return b+"..."+c
s=new A.ab(b)
$.cW.push(a)
try{r=s
r.a=A.oz(r.a,a,", ")}finally{$.cW.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
oO(a){var s,r
for(s=$.cW.length,r=0;r<s;++r)if(a===$.cW[r])return!0
return!1},
xk(a,b){var s,r,q,p,o,n,m,l=a.gD(a),k=0,j=0
while(!0){if(!(k<80||j<3))break
if(!l.p())return
s=A.b(l.gt())
b.push(s)
k+=s.length+2;++j}if(!l.p()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gt();++j
if(!l.p()){if(j<=4){b.push(A.b(p))
return}r=A.b(p)
q=b.pop()
k+=r.length+2}else{o=l.gt();++j
for(;l.p();p=o,o=n){n=l.gt();++j
if(j>100){while(!0){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.b(p)
r=A.b(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
while(!0){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
vF(a,b){var s,r,q=A.ks(b)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.cZ)(a),++r)q.w(0,a[r])
return q},
ow(a){var s,r={}
if(A.oO(a))return"{...}"
s=new A.ab("")
try{$.cW.push(a)
s.a+="{"
r.a=!0
a.K(0,new A.ku(r,s))
s.a+="}"}finally{$.cW.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
wG(){throw A.c(A.a1("Cannot change an unmodifiable set"))},
n6:function n6(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
el:function el(a,b,c,d){var _=this
_.x=a
_.y=b
_.z=c
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=d},
n4:function n4(a){this.a=a},
ba:function ba(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
n5:function n5(a){this.a=a
this.c=this.b=null},
cV:function cV(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
b7:function b7(a,b){this.a=a
this.$ti=b},
dN:function dN(){},
dW:function dW(){},
o:function o(){},
dX:function dX(){},
ku:function ku(a,b){this.a=a
this.b=b},
N:function N(){},
kv:function kv(a){this.a=a},
hp:function hp(){},
dY:function dY(){},
bw:function bw(a,b){this.a=a
this.$ti=b},
a4:function a4(){},
e6:function e6(){},
dn:function dn(){},
hq:function hq(){},
eD:function eD(a,b){this.a=a
this.$ti=b},
em:function em(){},
es:function es(){},
eC:function eC(){},
eH:function eH(){},
eI:function eI(){},
xq(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.X(r)
q=A.V(String(s),null,null)
throw A.c(q)}q=A.no(p)
return q},
no(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(Object.getPrototypeOf(a)!==Array.prototype)return new A.he(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.no(a[s])
return a},
wb(a,b,c,d){var s,r
if(b instanceof Uint8Array){s=b
d=s.length
if(d-c<15)return null
r=A.wc(a,s,c,d)
if(r!=null&&a)if(r.indexOf("\ufffd")>=0)return null
return r}return null},
wc(a,b,c,d){var s=a?$.us():$.ur()
if(s==null)return null
if(0===c&&d===b.length)return A.qf(s,b)
return A.qf(s,b.subarray(c,A.aS(c,d,b.length)))},
qf(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
pz(a,b,c,d,e,f){if(B.c.bi(f,4)!==0)throw A.c(A.V("Invalid base64 padding, padded length must be multiple of four, is "+f,a,c))
if(d+e!==f)throw A.c(A.V("Invalid base64 padding, '=' not at the end",a,b))
if(e>2)throw A.c(A.V("Invalid base64 padding, more than two '=' characters",a,b))},
wj(a,b,c,d,e,f){var s,r,q,p,o,n,m="Invalid encoding before padding",l="Invalid character",k=B.c.ae(f,2),j=f&3,i=$.pk()
for(s=b,r=0;s<c;++s){q=B.a.A(a,s)
r|=q
p=i[q&127]
if(p>=0){k=(k<<6|p)&16777215
j=j+1&3
if(j===0){o=e+1
d[e]=k>>>16&255
e=o+1
d[o]=k>>>8&255
o=e+1
d[e]=k&255
e=o
k=0}continue}else if(p===-1&&j>1){if(r>127)break
if(j===3){if((k&3)!==0)throw A.c(A.V(m,a,s))
d[e]=k>>>10
d[e+1]=k>>>2}else{if((k&15)!==0)throw A.c(A.V(m,a,s))
d[e]=k>>>4}n=(3-j)*3
if(q===37)n+=2
return A.qj(a,s+1,c,-n-1)}throw A.c(A.V(l,a,s))}if(r>=0&&r<=127)return(k<<2|j)>>>0
for(s=b;s<c;++s){q=B.a.A(a,s)
if(q>127)break}throw A.c(A.V(l,a,s))},
wh(a,b,c,d){var s=A.wi(a,b,c),r=(d&3)+(s-b),q=B.c.ae(r,2)*3,p=r&3
if(p!==0&&s<c)q+=p-1
if(q>0)return new Uint8Array(q)
return $.ut()},
wi(a,b,c){var s,r=c,q=r,p=0
while(!0){if(!(q>b&&p<2))break
c$0:{--q
s=B.a.A(a,q)
if(s===61){++p
r=q
break c$0}if((s|32)===100){if(q===b)break;--q
s=B.a.A(a,q)}if(s===51){if(q===b)break;--q
s=B.a.A(a,q)}if(s===37){++p
r=q
break c$0}break}}return r},
qj(a,b,c,d){var s,r
if(b===c)return d
s=-d-1
for(;s>0;){r=B.a.A(a,b)
if(s===3){if(r===61){s-=3;++b
break}if(r===37){--s;++b
if(b===c)break
r=B.a.A(a,b)}else break}if((s>3?s-3:s)===2){if(r!==51)break;++b;--s
if(b===c)break
r=B.a.A(a,b)}if((r|32)!==100)break;++b;--s
if(b===c)break}if(b!==c)throw A.c(A.V("Invalid padding character",a,b))
return-s-1},
pN(a,b,c){return new A.dS(a,b)},
x3(a){return a.eS()},
wl(a,b){return new A.hg(a,[],A.qU())},
wm(a,b,c){var s,r,q=new A.ab("")
if(c==null)s=A.wl(q,b)
else s=new A.n1(c,0,q,[],A.qU())
s.ar(a)
r=q.a
return r.charCodeAt(0)==0?r:r},
qz(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
wW(a,b,c){var s,r,q,p=c-b,o=new Uint8Array(p)
for(s=J.S(a),r=0;r<p;++r){q=s.j(a,b+r)
o[r]=(q&4294967040)>>>0!==0?255:q}return o},
he:function he(a,b){this.a=a
this.b=b
this.c=null},
hf:function hf(a){this.a=a},
mZ:function mZ(a,b,c){this.b=a
this.c=b
this.a=c},
mk:function mk(){},
mj:function mj(){},
hQ:function hQ(){},
hS:function hS(){},
hR:function hR(){},
mE:function mE(){this.a=0},
hT:function hT(){},
f0:function f0(){},
hi:function hi(a,b,c){this.a=a
this.b=b
this.$ti=c},
f4:function f4(){},
f6:function f6(){},
iJ:function iJ(){},
dS:function dS(a,b){this.a=a
this.b=b},
fm:function fm(a,b){this.a=a
this.b=b},
jx:function jx(){},
jy:function jy(a){this.a=a},
n2:function n2(){},
n3:function n3(a,b){this.a=a
this.b=b},
n_:function n_(){},
n0:function n0(a,b){this.a=a
this.b=b},
hg:function hg(a,b,c){this.c=a
this.a=b
this.b=c},
n1:function n1(a,b,c,d,e){var _=this
_.f=a
_.b$=b
_.c=c
_.a=d
_.b=e},
m8:function m8(){},
m9:function m9(){},
ew:function ew(){},
ni:function ni(a,b,c){this.a=a
this.b=b
this.c=c},
mh:function mh(){},
mi:function mi(a){this.a=a},
hr:function hr(a){this.a=a
this.b=16
this.c=0},
hs:function hs(){},
cY(a,b){var s=A.q5(a,b)
if(s!=null)return s
throw A.c(A.V(a,null,null))},
v9(a){if(a instanceof A.cj)return a.k(0)
return"Instance of '"+A.b(A.kT(a))+"'"},
va(a,b){a=A.c(a)
a.stack=J.aZ(b)
throw a
throw A.c("unreachable")},
W(a,b,c,d){var s,r=J.bm(a,d)
if(a!==0&&b!=null)for(s=0;s<a;++s)r[s]=b
return r},
ov(a,b){var s,r=A.a([],b.i("E<0>"))
for(s=a.gD(a);s.p();)r.push(s.gt())
return r},
d8(a,b,c){var s
if(b)return A.pP(a,c)
s=J.oq(A.pP(a,c))
return s},
pP(a,b){var s,r
if(Array.isArray(a))return A.a(a.slice(0),b.i("E<0>"))
s=A.a([],b.i("E<0>"))
for(r=J.ah(a);r.p();)s.push(r.gt())
return s},
pQ(a,b,c,d){var s,r=J.bm(a,d)
for(s=0;s<a;++s)r[s]=b.$1(s)
return r},
q9(a,b,c){if(t.bm.b(a))return A.vZ(a,b,A.aS(b,c,a.length))
return A.w7(a,b,c)},
w7(a,b,c){var s,r,q,p,o=null
if(b<0)throw A.c(A.a0(b,0,a.length,o,o))
s=c==null
if(!s&&c<b)throw A.c(A.a0(c,b,a.length,o,o))
r=new A.aq(a,a.length,A.al(a).i("aq<o.E>"))
for(q=0;q<b;++q)if(!r.p())throw A.c(A.a0(b,0,q,o,o))
p=[]
if(s)for(;r.p();)p.push(r.d)
else for(q=b;q<c;++q){if(!r.p())throw A.c(A.a0(c,b,q,o,o))
p.push(r.d)}return A.vX(p)},
ox(a){return new A.jr(a,A.vl(a,!1,!0,!1,!1,!1))},
oz(a,b,c){var s=J.ah(b)
if(!s.p())return a
if(c.length===0){do a+=A.b(s.gt())
while(s.p())}else{a+=A.b(s.gt())
for(;s.p();)a=a+c+A.b(s.gt())}return a},
pX(a,b,c,d){return new A.fB(a,b,c,d)},
v7(a,b){var s
if(Math.abs(a)<=864e13)s=!1
else s=!0
if(s)A.a3(A.an("DateTime is outside valid range: "+a,null))
A.cX(b,"isUtc",t.y)
return new A.ck(a,b)},
pG(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
v8(a){var s=Math.abs(a),r=a<0?"-":"+"
if(s>=1e5)return r+s
return r+"0"+s},
pH(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
bh(a){if(a>=10)return""+a
return"0"+a},
cl(a){if(typeof a=="number"||A.nD(a)||a==null)return J.aZ(a)
if(typeof a=="string")return JSON.stringify(a)
return A.v9(a)},
vb(a,b){A.cX(a,"error",t.K)
A.cX(b,"stackTrace",t.gm)
A.va(a,b)
A.b5(u.g)},
hN(a){return new A.eY(a)},
an(a,b){return new A.aN(!1,null,b,a)},
eX(a,b,c){return new A.aN(!0,a,b,c)},
hM(a,b){return a},
w0(a,b){return new A.e5(null,null,!0,a,b,"Value not in range")},
a0(a,b,c,d,e){return new A.e5(b,c,!0,a,d,"Invalid value")},
aS(a,b,c){if(0>a||a>c)throw A.c(A.a0(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.c(A.a0(b,a,c,"end",null))
return b}return c},
b4(a,b){if(a<0)throw A.c(A.a0(a,0,null,b,null))
return a},
d6(a,b,c,d,e){var s=e==null?J.a9(b):e
return new A.fh(s,!0,a,c,"Index out of range")},
a1(a){return new A.fW(a)},
qb(a){return new A.fR(a)},
bS(a){return new A.bR(a)},
aa(a){return new A.f5(a)},
V(a,b,c){return new A.bk(a,b,c)},
pK(a,b,c){if(a<=0)return new A.bj(c.i("bj<0>"))
return new A.ek(a,b,c.i("ek<0>"))},
pR(a,b,c,d,e){return new A.ci(a,b.i("@<0>").G(c).G(d).G(e).i("ci<1,2,3,4>"))},
kO(a){var s,r,q=$.uv()
for(s=a.length,r=0;r<s;++r){q=q+B.C.gC(a[r])&536870911
q=q+((q&524287)<<10)&536870911
q^=q>>>6}q=q+((q&67108863)<<3)&536870911
q^=q>>>11
return q+((q&16383)<<15)&536870911},
hE(a){A.yC(a)},
qd(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=null,a5=a6.length
if(a5>=5){s=A.qO(a6,0)
if(s===0)return A.md(a5<a5?B.a.u(a6,0,a5):a6,5,a4).gdg()
else if(s===32)return A.md(B.a.u(a6,5,a5),0,a4).gdg()}r=A.W(8,0,!1,t.S)
r[0]=0
r[1]=-1
r[2]=-1
r[7]=-1
r[3]=0
r[4]=0
r[5]=a5
r[6]=a5
if(A.qM(a6,0,a5,0,r)>=14)r[7]=a5
q=r[1]
if(q>=0)if(A.qM(a6,0,q,20,r)===20)r[7]=q
p=r[2]+1
o=r[3]
n=r[4]
m=r[5]
l=r[6]
if(l<m)m=l
if(n<p)n=m
else if(n<=q)n=q+1
if(o<p)o=n
k=r[7]<0
if(k)if(p>q+3){j=a4
k=!1}else{i=o>0
if(i&&o+1===n){j=a4
k=!1}else{if(!(m<a5&&m===n+2&&B.a.W(a6,"..",n)))h=m>n+2&&B.a.W(a6,"/..",m-3)
else h=!0
if(h){j=a4
k=!1}else{if(q===4)if(B.a.W(a6,"file",0)){if(p<=0){if(!B.a.W(a6,"/",n)){g="file:///"
f=3}else{g="file://"
f=2}a6=g+B.a.u(a6,n,a5)
q-=0
i=f-0
m+=i
l+=i
a5=a6.length
p=7
o=7
n=7}else if(n===m){++l
e=m+1
a6=B.a.ay(a6,n,m,"/");++a5
m=e}j="file"}else if(B.a.W(a6,"http",0)){if(i&&o+3===n&&B.a.W(a6,"80",o+1)){l-=3
d=n-3
m-=3
a6=B.a.ay(a6,o,n,"")
a5-=3
n=d}j="http"}else j=a4
else if(q===5&&B.a.W(a6,"https",0)){if(i&&o+4===n&&B.a.W(a6,"443",o+1)){l-=4
d=n-4
m-=4
a6=B.a.ay(a6,o,n,"")
a5-=3
n=d}j="https"}else j=a4
k=!0}}}else j=a4
if(k){if(a5<a6.length){a6=B.a.u(a6,0,a5)
q-=0
p-=0
o-=0
n-=0
m-=0
l-=0}return new A.hj(a6,q,p,o,n,m,l,j)}if(j==null)if(q>0)j=A.wQ(a6,0,q)
else{if(q===0){A.dq(a6,0,"Invalid empty scheme")
A.b5(u.g)}j=""}if(p>0){c=q+3
b=c<p?A.wR(a6,c,p-1):""
a=A.wM(a6,p,o,!1)
i=o+1
if(i<n){a0=A.q5(B.a.u(a6,i,n),a4)
a1=A.wO(a0==null?A.a3(A.V("Invalid port",a6,i)):a0,j)}else a1=a4}else{a1=a4
a=a1
b=""}a2=A.wN(a6,n,m,a4,j,a!=null)
a3=m<l?A.wP(a6,m+1,l,a4):a4
return A.wH(j,b,a,a1,a2,a3,l<a5?A.wL(a6,l+1,a5):a4)},
wa(a,b,c){var s,r,q,p,o,n,m="IPv4 address should contain exactly 4 parts",l="each part must be in the range 0..255",k=new A.me(a),j=new Uint8Array(4)
for(s=b,r=s,q=0;s<c;++s){p=B.a.A(a,s)
if(p!==46){if((p^48)>9)k.$2("invalid character",s)}else{if(q===3)k.$2(m,s)
o=A.cY(B.a.u(a,r,s),null)
if(o>255)k.$2(l,r)
n=q+1
j[q]=o
r=s+1
q=n}}if(q!==3)k.$2(m,c)
o=A.cY(B.a.u(a,r,c),null)
if(o>255)k.$2(l,r)
j[q]=o
return j},
qe(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d=new A.mf(a),c=new A.mg(d,a)
if(a.length<2)d.$2("address is too short",e)
s=A.a([],t.Y)
for(r=b,q=r,p=!1,o=!1;r<a0;++r){n=B.a.A(a,r)
if(n===58){if(r===b){++r
if(B.a.A(a,r)!==58)d.$2("invalid start colon.",r)
q=r}if(r===q){if(p)d.$2("only one wildcard `::` is allowed",r)
s.push(-1)
p=!0}else s.push(c.$2(q,r))
q=r+1}else if(n===46)o=!0}if(s.length===0)d.$2("too few parts",e)
m=q===a0
l=B.d.gaL(s)
if(m&&l!==-1)d.$2("expected a part after last `:`",a0)
if(!m)if(!o)s.push(c.$2(q,a0))
else{k=A.wa(a,q,a0)
s.push((k[0]<<8|k[1])>>>0)
s.push((k[2]<<8|k[3])>>>0)}if(p){if(s.length>7)d.$2("an address with a wildcard must have less than 7 parts",e)}else if(s.length!==8)d.$2("an address without a wildcard must contain exactly 8 parts",e)
j=new Uint8Array(16)
for(l=s.length,i=9-l,r=0,h=0;r<l;++r){g=s[r]
if(g===-1)for(f=0;f<i;++f){j[h]=0
j[h+1]=0
h+=2}else{j[h]=B.c.ae(g,8)
j[h+1]=g&255
h+=2}}return j},
wH(a,b,c,d,e,f,g){return new A.eE(a,b,c,d,e,f,g)},
qs(a){if(a==="http")return 80
if(a==="https")return 443
return 0},
dq(a,b,c){throw A.c(A.V(c,a,b))},
wO(a,b){var s=A.qs(b)
if(a===s)return null
return a},
wM(a,b,c,d){var s,r,q,p,o,n
if(a==null)return null
if(b===c)return""
if(B.a.A(a,b)===91){s=c-1
if(B.a.A(a,s)!==93){A.dq(a,b,"Missing end `]` to match `[` in host")
A.b5(u.g)}r=b+1
q=A.wJ(a,r,s)
if(q<s){p=q+1
o=A.qx(a,B.a.W(a,"25",p)?q+3:p,s,"%25")}else o=""
A.qe(a,r,q)
return B.a.u(a,b,q).toLowerCase()+o+"]"}for(n=b;n<c;++n)if(B.a.A(a,n)===58){q=B.a.b8(a,"%",b)
q=q>=b&&q<c?q:c
if(q<c){p=q+1
o=A.qx(a,B.a.W(a,"25",p)?q+3:p,c,"%25")}else o=""
A.qe(a,b,q)
return"["+B.a.u(a,b,q)+o+"]"}return A.wT(a,b,c)},
wJ(a,b,c){var s=B.a.b8(a,"%",b)
return s>=b&&s<c?s:c},
qx(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=d!==""?new A.ab(d):null
for(s=b,r=s,q=!0;s<c;){p=B.a.A(a,s)
if(p===37){o=A.oG(a,s,!0)
n=o==null
if(n&&q){s+=3
continue}if(i==null)i=new A.ab("")
m=i.a+=B.a.u(a,r,s)
if(n)o=B.a.u(a,s,s+3)
else if(o==="%"){A.dq(a,s,"ZoneID should not contain % anymore")
A.b5(u.g)}i.a=m+o
s+=3
r=s
q=!0}else if(p<127&&(B.au[p>>>4]&1<<(p&15))!==0){if(q&&65<=p&&90>=p){if(i==null)i=new A.ab("")
if(r<s){i.a+=B.a.u(a,r,s)
r=s}q=!1}++s}else{if((p&64512)===55296&&s+1<c){l=B.a.A(a,s+1)
if((l&64512)===56320){p=(p&1023)<<10|l&1023|65536
k=2}else k=1}else k=1
j=B.a.u(a,r,s)
if(i==null){i=new A.ab("")
n=i}else n=i
n.a+=j
n.a+=A.oF(p)
s+=k
r=s}}if(i==null)return B.a.u(a,b,c)
if(r<c)i.a+=B.a.u(a,r,c)
n=i.a
return n.charCodeAt(0)==0?n:n},
wT(a,b,c){var s,r,q,p,o,n,m,l,k,j,i
for(s=b,r=s,q=null,p=!0;s<c;){o=B.a.A(a,s)
if(o===37){n=A.oG(a,s,!0)
m=n==null
if(m&&p){s+=3
continue}if(q==null)q=new A.ab("")
l=B.a.u(a,r,s)
k=q.a+=!p?l.toLowerCase():l
if(m){n=B.a.u(a,s,s+3)
j=3}else if(n==="%"){n="%25"
j=1}else j=3
q.a=k+n
s+=j
r=s
p=!0}else if(o<127&&(B.cZ[o>>>4]&1<<(o&15))!==0){if(p&&65<=o&&90>=o){if(q==null)q=new A.ab("")
if(r<s){q.a+=B.a.u(a,r,s)
r=s}p=!1}++s}else if(o<=93&&(B.am[o>>>4]&1<<(o&15))!==0){A.dq(a,s,"Invalid character")
A.b5(u.g)}else{if((o&64512)===55296&&s+1<c){i=B.a.A(a,s+1)
if((i&64512)===56320){o=(o&1023)<<10|i&1023|65536
j=2}else j=1}else j=1
l=B.a.u(a,r,s)
if(!p)l=l.toLowerCase()
if(q==null){q=new A.ab("")
m=q}else m=q
m.a+=l
m.a+=A.oF(o)
s+=j
r=s}}if(q==null)return B.a.u(a,b,c)
if(r<c){l=B.a.u(a,r,c)
q.a+=!p?l.toLowerCase():l}m=q.a
return m.charCodeAt(0)==0?m:m},
wQ(a,b,c){var s,r,q,p=u.g
if(b===c)return""
if(!A.qu(J.pt(a,b))){A.dq(a,b,"Scheme not starting with alphabetic character")
A.b5(p)}for(s=b,r=!1;s<c;++s){q=B.a.E(a,s)
if(!(q<128&&(B.ar[q>>>4]&1<<(q&15))!==0)){A.dq(a,s,"Illegal scheme character")
A.b5(p)}if(65<=q&&q<=90)r=!0}a=B.a.u(a,b,c)
return A.wI(r?a.toLowerCase():a)},
wI(a){if(a==="http")return"http"
if(a==="file")return"file"
if(a==="https")return"https"
if(a==="package")return"package"
return a},
wR(a,b,c){if(a==null)return""
return A.eF(a,b,c,B.cE,!1)},
wN(a,b,c,d,e,f){var s,r=e==="file",q=r||f
if(a==null)return r?"/":""
else s=A.eF(a,b,c,B.aw,!0)
if(s.length===0){if(r)return"/"}else if(q&&!B.a.V(s,"/"))s="/"+s
return A.wS(s,e,f)},
wS(a,b,c){var s=b.length===0
if(s&&!c&&!B.a.V(a,"/"))return A.wU(a,!s||c)
return A.wV(a)},
wP(a,b,c,d){if(a!=null)return A.eF(a,b,c,B.E,!0)
return null},
wL(a,b,c){if(a==null)return null
return A.eF(a,b,c,B.E,!0)},
oG(a,b,c){var s,r,q,p,o,n=b+2
if(n>=a.length)return"%"
s=B.a.A(a,b+1)
r=B.a.A(a,n)
q=A.nU(s)
p=A.nU(r)
if(q<0||p<0)return"%"
o=q*16+p
if(o<127&&(B.au[B.c.ae(o,4)]&1<<(o&15))!==0)return A.P(c&&65<=o&&90>=o?(o|32)>>>0:o)
if(s>=97||r>=97)return B.a.u(a,b,b+3).toUpperCase()
return null},
oF(a){var s,r,q,p,o,n="0123456789ABCDEF"
if(a<128){s=new Uint8Array(3)
s[0]=37
s[1]=B.a.E(n,a>>>4)
s[2]=B.a.E(n,a&15)}else{if(a>2047)if(a>65535){r=240
q=4}else{r=224
q=3}else{r=192
q=2}s=new Uint8Array(3*q)
for(p=0;--q,q>=0;r=128){o=B.c.ea(a,6*q)&63|r
s[p]=37
s[p+1]=B.a.E(n,o>>>4)
s[p+2]=B.a.E(n,o&15)
p+=3}}return A.q9(s,0,null)},
eF(a,b,c,d,e){var s=A.qw(a,b,c,d,e)
return s==null?B.a.u(a,b,c):s},
qw(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=null
for(s=!e,r=b,q=r,p=j;r<c;){o=B.a.A(a,r)
if(o<127&&(d[o>>>4]&1<<(o&15))!==0)++r
else{if(o===37){n=A.oG(a,r,!1)
if(n==null){r+=3
continue}if("%"===n){n="%25"
m=1}else m=3}else if(s&&o<=93&&(B.am[o>>>4]&1<<(o&15))!==0){A.dq(a,r,"Invalid character")
A.b5(u.g)
m=j
n=m}else{if((o&64512)===55296){l=r+1
if(l<c){k=B.a.A(a,l)
if((k&64512)===56320){o=(o&1023)<<10|k&1023|65536
m=2}else m=1}else m=1}else m=1
n=A.oF(o)}if(p==null){p=new A.ab("")
l=p}else l=p
l.a+=B.a.u(a,q,r)
l.a+=A.b(n)
r+=m
q=r}}if(p==null)return j
if(q<c)p.a+=B.a.u(a,q,c)
s=p.a
return s.charCodeAt(0)==0?s:s},
qv(a){if(B.a.V(a,"."))return!0
return B.a.bN(a,"/.")!==-1},
wV(a){var s,r,q,p,o,n
if(!A.qv(a))return a
s=A.a([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(J.am(n,"..")){if(s.length!==0){s.pop()
if(s.length===0)s.push("")}p=!0}else if("."===n)p=!0
else{s.push(n)
p=!1}}if(p)s.push("")
return B.d.aj(s,"/")},
wU(a,b){var s,r,q,p,o,n
if(!A.qv(a))return!b?A.qt(a):a
s=A.a([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(".."===n)if(s.length!==0&&B.d.gaL(s)!==".."){s.pop()
p=!0}else{s.push("..")
p=!1}else if("."===n)p=!0
else{s.push(n)
p=!1}}r=s.length
if(r!==0)r=r===1&&s[0].length===0
else r=!0
if(r)return"./"
if(p||B.d.gaL(s)==="..")s.push("")
if(!b)s[0]=A.qt(s[0])
return B.d.aj(s,"/")},
qt(a){var s,r,q=a.length
if(q>=2&&A.qu(B.a.E(a,0)))for(s=1;s<q;++s){r=B.a.E(a,s)
if(r===58)return B.a.u(a,0,s)+"%3A"+B.a.aU(a,s+1)
if(r>127||(B.ar[r>>>4]&1<<(r&15))===0)break}return a},
wK(a,b){var s,r,q
for(s=0,r=0;r<2;++r){q=B.a.A(a,b+r)
if(48<=q&&q<=57)s=s*16+q-48
else{q|=32
if(97<=q&&q<=102)s=s*16+q-87
else throw A.c(A.an("Invalid URL encoding",null))}}return s},
qy(a,b,c,d,e){var s,r,q,p,o=b
while(!0){if(!(o<c)){s=!0
break}r=B.a.A(a,o)
if(r<=127)if(r!==37)q=!1
else q=!0
else q=!0
if(q){s=!1
break}++o}if(s){if(B.N!==d)q=!1
else q=!0
if(q)return B.a.u(a,b,c)
else p=new A.d2(B.a.u(a,b,c))}else{p=A.a([],t.Y)
for(q=a.length,o=b;o<c;++o){r=B.a.A(a,o)
if(r>127)throw A.c(A.an("Illegal percent encoding in URI",null))
if(r===37){if(o+3>q)throw A.c(A.an("Truncated URI",null))
p.push(A.wK(a,o+1))
o+=2}else p.push(r)}}return B.e8.eh(p)},
qu(a){var s=a|32
return 97<=s&&s<=122},
qc(a){var s
if(a.length>=5){s=A.qO(a,0)
if(s===0)return A.md(a,5,null)
if(s===32)return A.md(B.a.aU(a,5),0,null)}throw A.c(A.V("Does not start with 'data:'",a,0))},
md(a,b,c){var s,r,q,p,o,n,m,l,k="Invalid MIME type",j=A.a([b-1],t.Y)
for(s=a.length,r=b,q=-1,p=null;r<s;++r){p=B.a.E(a,r)
if(p===44||p===59)break
if(p===47){if(q<0){q=r
continue}throw A.c(A.V(k,a,r))}}if(q<0&&r>b)throw A.c(A.V(k,a,r))
for(;p!==44;){j.push(r);++r
for(o=-1;r<s;++r){p=B.a.E(a,r)
if(p===61){if(o<0)o=r}else if(p===59||p===44)break}if(o>=0)j.push(o)
else{n=B.d.gaL(j)
if(p!==44||r!==n+7||!B.a.W(a,"base64",n+1))throw A.c(A.V("Expecting '='",a,r))
break}}j.push(r)
m=r+1
if((j.length&1)===1)a=B.b6.ey(a,m,s)
else{l=A.qw(a,m,s,B.E,!0)
if(l!=null)a=B.a.ay(a,m,s,l)}return new A.mc(a,j,c)},
x1(){var s,r,q,p,o,n="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._~!$&'()*+,;=",m=".",l=":",k="/",j="?",i="#",h=A.a(new Array(22),t.gN)
for(s=0;s<22;++s)h[s]=new Uint8Array(96)
r=new A.nr(h)
q=new A.ns()
p=new A.nt()
o=r.$2(0,225)
q.$3(o,n,1)
q.$3(o,m,14)
q.$3(o,l,34)
q.$3(o,k,3)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(14,225)
q.$3(o,n,1)
q.$3(o,m,15)
q.$3(o,l,34)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(15,225)
q.$3(o,n,1)
q.$3(o,"%",225)
q.$3(o,l,34)
q.$3(o,k,9)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(1,225)
q.$3(o,n,1)
q.$3(o,l,34)
q.$3(o,k,10)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(2,235)
q.$3(o,n,139)
q.$3(o,k,131)
q.$3(o,m,146)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(3,235)
q.$3(o,n,11)
q.$3(o,k,68)
q.$3(o,m,18)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(4,229)
q.$3(o,n,5)
p.$3(o,"AZ",229)
q.$3(o,l,102)
q.$3(o,"@",68)
q.$3(o,"[",232)
q.$3(o,k,138)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(5,229)
q.$3(o,n,5)
p.$3(o,"AZ",229)
q.$3(o,l,102)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(6,231)
p.$3(o,"19",7)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(7,231)
p.$3(o,"09",7)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,172)
q.$3(o,i,205)
q.$3(r.$2(8,8),"]",5)
o=r.$2(9,235)
q.$3(o,n,11)
q.$3(o,m,16)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(16,235)
q.$3(o,n,11)
q.$3(o,m,17)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(17,235)
q.$3(o,n,11)
q.$3(o,k,9)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(10,235)
q.$3(o,n,11)
q.$3(o,m,18)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(18,235)
q.$3(o,n,11)
q.$3(o,m,19)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(19,235)
q.$3(o,n,11)
q.$3(o,k,234)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(11,235)
q.$3(o,n,11)
q.$3(o,k,10)
q.$3(o,j,172)
q.$3(o,i,205)
o=r.$2(12,236)
q.$3(o,n,12)
q.$3(o,j,12)
q.$3(o,i,205)
o=r.$2(13,237)
q.$3(o,n,13)
q.$3(o,j,13)
p.$3(r.$2(20,245),"az",21)
o=r.$2(21,245)
p.$3(o,"az",21)
p.$3(o,"09",21)
q.$3(o,"+-.",21)
return h},
qM(a,b,c,d,e){var s,r,q,p,o,n=$.uA()
for(s=J.hD(a),r=b;r<c;++r){q=n[d]
p=s.E(a,r)^96
o=q[p>95?31:p]
d=o&31
e[o>>>5]=r}return d},
qO(a,b){return((J.pt(a,b+4)^58)*3|B.a.E(a,b)^100|B.a.E(a,b+1)^97|B.a.E(a,b+2)^116|B.a.E(a,b+3)^97)>>>0},
kK:function kK(a,b){this.a=a
this.b=b},
ck:function ck(a,b){this.a=a
this.b=b},
mH:function mH(){},
G:function G(){},
eY:function eY(a){this.a=a},
b6:function b6(){},
fC:function fC(){},
aN:function aN(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e5:function e5(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fh:function fh(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
fB:function fB(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fW:function fW(a){this.a=a},
fR:function fR(a){this.a=a},
bR:function bR(a){this.a=a},
f5:function f5(a){this.a=a},
fE:function fE(){},
e8:function e8(){},
f8:function f8(a){this.a=a},
h9:function h9(a){this.a=a},
bk:function bk(a,b,c){this.a=a
this.b=b
this.c=c},
t:function t(){},
ek:function ek(a,b,c){this.a=a
this.b=b
this.$ti=c},
R:function R(){},
d9:function d9(a,b,c){this.a=a
this.b=b
this.$ti=c},
m:function m(){},
e:function e(){},
hm:function hm(){},
m3:function m3(){this.b=this.a=0},
ab:function ab(a){this.a=a},
me:function me(a){this.a=a},
mf:function mf(a){this.a=a},
mg:function mg(a,b){this.a=a
this.b=b},
eE:function eE(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.x=$},
mc:function mc(a,b,c){this.a=a
this.b=b
this.c=c},
nr:function nr(a){this.a=a},
ns:function ns(){},
nt:function nt(){},
hj:function hj(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.x=h
_.y=null},
h4:function h4(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.x=$},
cU(a,b,c,d){var s=new A.h8(a,b,c==null?null:A.qR(new A.mI(c),t.A),!1)
s.cC()
return s},
qR(a,b){var s=$.F
if(s===B.i)return a
return s.ef(a,b)},
eQ(a){return document.querySelector(a)},
k:function k(){},
eU:function eU(){},
eW:function eW(){},
cd:function cd(){},
b0:function b0(){},
dC:function dC(){},
i6:function i6(){},
iH:function iH(){},
iI:function iI(){},
dD:function dD(){},
j:function j(){},
f9:function f9(){},
as:function as(){},
dG:function dG(){},
fa:function fa(){},
fb:function fb(){},
dL:function dL(){},
kt:function kt(){},
aK:function aK(){},
M:function M(){},
b3:function b3(){},
fM:function fM(){},
aW:function aW(){},
dh:function dh(){},
bx:function bx(){},
en:function en(){},
h6:function h6(a){this.a=a},
op:function op(a,b){this.a=a
this.$ti=b},
cT:function cT(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
ax:function ax(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
h8:function h8(a,b,c,d){var _=this
_.a=0
_.b=a
_.c=b
_.d=c
_.e=d},
mI:function mI(a){this.a=a},
mJ:function mJ(a){this.a=a},
bl:function bl(){},
dI:function dI(a,b,c){var _=this
_.a=a
_.b=b
_.c=-1
_.d=null
_.$ti=c},
h3:function h3(){},
ha:function ha(){},
hb:function hb(){},
ht:function ht(){},
hu:function hu(){},
f7:function f7(){},
i4:function i4(a){this.a=a},
i5:function i5(){},
dT:function dT(){},
x_(a,b,c,d){var s,r,q
if(b){s=[c]
B.d.H(s,d)
d=s}r=t.z
q=A.ov(J.bc(d,A.yd(),r),r)
return A.oI(A.vU(a,q,null))},
oJ(a,b,c){var s
try{if(Object.isExtensible(a)&&!Object.prototype.hasOwnProperty.call(a,b)){Object.defineProperty(a,b,{value:c})
return!0}}catch(s){}return!1},
qH(a,b){if(Object.prototype.hasOwnProperty.call(a,b))return a[b]
return null},
oI(a){if(a==null||typeof a=="string"||typeof a=="number"||A.nD(a))return a
if(a instanceof A.bo)return a.a
if(A.r4(a))return a
if(t.Q.b(a))return a
if(a instanceof A.ck)return A.au(a)
if(t.k.b(a))return A.qG(a,"$dart_jsFunction",new A.np())
return A.qG(a,"_$dart_jsObject",new A.nq($.pm()))},
qG(a,b,c){var s=A.qH(a,b)
if(s==null){s=c.$1(a)
A.oJ(a,b,s)}return s},
oH(a){var s,r
if(a==null||typeof a=="string"||typeof a=="number"||typeof a=="boolean")return a
else if(a instanceof Object&&A.r4(a))return a
else if(a instanceof Object&&t.Q.b(a))return a
else if(a instanceof Date){s=a.getTime()
if(Math.abs(s)<=864e13)r=!1
else r=!0
if(r)A.a3(A.an("DateTime is outside valid range: "+A.b(s),null))
A.cX(!1,"isUtc",t.y)
return new A.ck(s,!1)}else if(a.constructor===$.pm())return a.o
else return A.qQ(a)},
qQ(a){if(typeof a=="function")return A.oK(a,$.ob(),new A.nK())
if(a instanceof Array)return A.oK(a,$.pl(),new A.nL())
return A.oK(a,$.pl(),new A.nM())},
oK(a,b,c){var s=A.qH(a,b)
if(s==null||!(a instanceof Object)){s=c.$1(a)
A.oJ(a,b,s)}return s},
np:function np(){},
nq:function nq(a){this.a=a},
nK:function nK(){},
nL:function nL(){},
nM:function nM(){},
bo:function bo(a){this.a=a},
dR:function dR(a){this.a=a},
ct:function ct(a,b){this.a=a
this.$ti=b},
dm:function dm(){},
f_:function f_(a){this.a=a},
l:function l(){},
uP(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f="byteOffset",e=null,d="normalized"
A.z(a,B.cN,b)
s=A.a_(a,"bufferView",b,!1)
if(s===-1){r=a.B(f)
if(r)b.l($.d_(),A.a(["bufferView"],t.M),f)
q=0}else q=A.a6(a,f,b,0,e,-1,0,!1)
p=A.a6(a,"componentType",b,-1,B.ck,-1,0,!0)
o=A.a6(a,"count",b,-1,e,-1,1,!0)
n=A.O(a,"type",b,e,B.m.gM(),e,!0)
m=A.qY(a,d,b)
if(n!=null&&p!==-1){l=B.m.j(0,n)
if(l!=null)if(p===5126){r=t.V
k=A.ag(a,"min",b,e,A.a([l],r),1/0,-1/0,!0)
j=A.ag(a,"max",b,e,A.a([l],r),1/0,-1/0,!0)}else{k=A.qZ(a,"min",b,p,l)
j=A.qZ(a,"max",b,p,l)}else{k=e
j=k}}else{k=e
j=k}i=A.Y(a,"sparse",b,A.xF(),!1)
if(m)r=p===5126||p===5125
else r=!1
if(r)b.n($.tD(),d)
if((n==="MAT2"||n==="MAT3"||n==="MAT4")&&q!==-1&&(q&3)!==0)b.n($.tC(),f)
switch(p){case 5120:case 5121:case 5122:case 5123:case 5125:A.O(a,"name",b,e,e,e,!1)
r=A.w(a,B.S,b,e)
h=A.A(a,b)
g=new A.fZ(s,q,p,o,n,m,j,k,i,A.bb(p),r,h,!1)
if(k!=null){r=b.R()
h=t.e
b.Z(g,new A.fs(A.W(k.length,0,!1,h),A.W(k.length,0,!1,h),J.hJ(k,!1),r))}if(j!=null){r=b.R()
h=t.e
b.Z(g,new A.fq(A.W(j.length,0,!1,h),A.W(j.length,0,!1,h),J.hJ(j,!1),r))}break
default:A.O(a,"name",b,e,e,e,!1)
r=A.w(a,B.S,b,e)
h=A.A(a,b)
g=new A.fY(s,q,p,o,n,m,j,k,i,A.bb(p),r,h,!1)
b.Z(g,new A.fj(b.R()))
if(k!=null){r=b.R()
b.Z(g,new A.fr(A.W(k.length,0,!1,t.e),A.W(k.length,0,!1,t.F),J.hJ(k,!1),r))}if(j!=null){r=b.R()
b.Z(g,new A.fp(A.W(j.length,0,!1,t.e),A.W(j.length,0,!1,t.F),J.hJ(j,!1),r))}break}return g},
bE(a,b,c,d,e,f){var s,r,q="byteOffset"
if(a===-1)return!1
if(a%b!==0)if(f!=null)f.l($.tE(),A.a([a,b],t.M),q)
else return!1
s=d.y
if(s===-1)return!1
r=s+a
if(r%b!==0)if(f!=null)f.F($.rY(),A.a([r,b],t.M))
else return!1
s=d.z
if(a>s)if(f!=null)f.l($.p2(),A.a([a,c,e,s],t.M),q)
else return!1
else if(a+c>s)if(f!=null)f.F($.p2(),A.a([a,c,e,s],t.M))
else return!1
return!0},
oo(a,b,c,d){var s=b.byteLength,r=A.bb(a)
if(s<c+r*d)return null
switch(a){case 5121:return A.kJ(b,c,d)
case 5123:return A.pV(b,c,d)
case 5125:return A.pW(b,c,d)
default:return null}},
px(a,b,c,d){var s=b.byteLength,r=A.bb(a)
if(s<c+r*d)return null
switch(a){case 5126:A.ds(b,c,d)
return new Float32Array(b,c,d)
default:return null}},
py(a,b,c,d){var s=b.byteLength,r=A.bb(a)
if(s<c+r*d)return null
switch(a){case 5120:A.ds(b,c,d)
s=new Int8Array(b,c,d)
return s
case 5121:return A.kJ(b,c,d)
case 5122:A.ds(b,c,d)
return new Int16Array(b,c,d)
case 5123:return A.pV(b,c,d)
case 5125:return A.pW(b,c,d)
default:return null}},
uO(a,b){var s,r,q
A.z(a,B.cw,b)
s=A.a6(a,"count",b,-1,null,-1,1,!0)
r=A.Y(a,"indices",b,A.xD(),!0)
q=A.Y(a,"values",b,A.xE(),!0)
if(s===-1||r==null||q==null)return null
return new A.c8(s,r,q,A.w(a,B.dD,b,null),A.A(a,b),!1)},
uM(a,b){A.z(a,B.cp,b)
return new A.c9(A.a_(a,"bufferView",b,!0),A.a6(a,"byteOffset",b,0,null,-1,0,!1),A.a6(a,"componentType",b,-1,B.c7,-1,0,!0),A.w(a,B.dB,b,null),A.A(a,b),!1)},
uN(a,b){A.z(a,B.cs,b)
return new A.ca(A.a_(a,"bufferView",b,!0),A.a6(a,"byteOffset",b,0,null,-1,0,!1),A.w(a,B.dC,b,null),A.A(a,b),!1)},
ad:function ad(){},
fZ:function fZ(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ch=e
_.cx=f
_.cy=g
_.db=h
_.dx=i
_.dy=j
_.fr=null
_.fx=0
_.k2=_.k1=null
_.a=k
_.b=l
_.a$=m},
mw:function mw(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mx:function mx(a){this.a=a},
my:function my(){},
mz:function mz(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mu:function mu(a){this.a=a},
mv:function mv(a){this.a=a},
fY:function fY(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ch=e
_.cx=f
_.cy=g
_.db=h
_.dx=i
_.dy=j
_.fr=null
_.fx=0
_.k2=_.k1=null
_.a=k
_.b=l
_.a$=m},
mq:function mq(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mr:function mr(a){this.a=a},
ms:function ms(){},
mt:function mt(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
c8:function c8(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.a=d
_.b=e
_.a$=f},
c9:function c9(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.a$=f},
ca:function ca(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
fj:function fj(a){this.a=a},
fr:function fr(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fp:function fp(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fs:function fs(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fq:function fq(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uR(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null,b="channels",a="extras",a0="samplers"
A.z(a1,B.cu,a2)
s=A.eP(a1,b,a2)
if(s!=null){r=s.gh(s)
q=A.W(r,c,!1,t.aA)
p=new A.H(q,r,b,t.eq)
r=a2.c
r.push(b)
for(o=t.h,n=0;n<s.gh(s);++n){m=s.j(0,n)
r.push(B.c.k(n))
A.z(m,B.d6,a2)
l=A.a_(m,"sampler",a2,!0)
k=A.Y(m,"target",a2,A.xH(),!0)
j=A.w(m,B.dF,a2,c)
i=m.j(0,a)
h=i!=null&&!o.b(i)
if(h)a2.n($.dy(),a)
q[n]=new A.bd(l,k,j,i,!1)
r.pop()}r.pop()}else p=c
g=A.eP(a1,a0,a2)
if(g!=null){r=g.gh(g)
q=A.W(r,c,!1,t.hc)
f=new A.H(q,r,a0,t.az)
r=a2.c
r.push(a0)
for(o=t.h,n=0;n<g.gh(g);++n){e=g.j(0,n)
r.push(B.c.k(n))
A.z(e,B.cK,a2)
l=A.a_(e,"input",a2,!0)
k=A.O(e,"interpolation",a2,"LINEAR",B.ch,c,!1)
j=A.a_(e,"output",a2,!0)
h=A.w(e,B.dG,a2,c)
i=e.j(0,a)
d=i!=null&&!o.b(i)
if(d)a2.n($.dy(),a)
q[n]=new A.be(l,k,j,h,i,!1)
r.pop()}r.pop()}else f=c
A.O(a1,"name",a2,c,c,c,!1)
return new A.bF(p,f,A.w(a1,B.aB,a2,c),A.A(a1,a2),!1)},
uQ(a,b){A.z(a,B.cS,b)
return new A.cc(A.a_(a,"node",b,!1),A.O(a,"path",b,null,B.ax,null,!0),A.w(a,B.dE,b,null),A.A(a,b),!1)},
bF:function bF(a,b,c,d,e){var _=this
_.x=a
_.y=b
_.a=c
_.b=d
_.a$=e},
hK:function hK(a,b){this.a=a
this.b=b},
hL:function hL(a,b,c){this.a=a
this.b=b
this.c=c},
bd:function bd(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
cc:function cc(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
be:function be(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.x=_.r=null
_.a=d
_.b=e
_.a$=f},
eV:function eV(a){this.a=0
this.b=a},
e4:function e4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0
_.$ti=d},
uS(a,b){var s,r,q,p,o=null,n="minVersion"
A.z(a,B.cr,b)
A.O(a,"copyright",b,o,o,o,!1)
s=A.O(a,"generator",b,o,o,o,!1)
r=$.bC()
q=A.O(a,"version",b,o,o,r,!0)
r=A.O(a,n,b,o,o,r,!1)
p=new A.bG(s,q,r,A.w(a,B.dH,b,o),A.A(a,b),!1)
s=r!=null&&q!=null
if(s){if(p.gcW()<=p.gba())s=p.gcW()===p.gba()&&p.gex()>p.gbP()
else s=!0
if(s)b.l($.u_(),A.a([r,q],t.M),n)}return p},
bG:function bG(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.r=c
_.a=d
_.b=e
_.a$=f},
uW(a,b){var s,r,q,p,o,n,m,l,k=null,j="uri"
A.z(a,B.d8,b)
p=A.a6(a,"byteLength",b,-1,k,-1,1,!0)
s=null
o=a.B(j)
if(o){r=A.O(a,j,b,k,k,k,!1)
if(r!=null){if(b.id)b.n($.p1(),j)
q=null
try{q=A.qc(r)}catch(n){if(A.X(n) instanceof A.bk)s=A.r2(r,b)
else throw n}if(q!=null){if(b.id)b.n($.p0(),j)
switch(q.gbO().toLowerCase()){case"application/gltf-buffer":case"application/octet-stream":m=q.cI()
break
default:b.l($.tH(),A.a([q.gbO()],t.M),j)
m=k
break}}else m=k}else m=k
o=!0}else m=k
l=s
A.O(a,"name",b,k,k,k,!1)
return new A.b_(l,p,o,m,A.w(a,B.dI,b,k),A.A(a,b),!1)},
b_:function b_(a,b,c,d,e,f,g){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.a=e
_.b=f
_.a$=g},
uV(a,b){var s,r,q,p,o,n=null,m="byteStride"
A.z(a,B.cg,b)
s=A.a6(a,"byteLength",b,-1,n,-1,1,!0)
r=A.a6(a,m,b,-1,n,252,4,!1)
q=A.a6(a,"target",b,-1,B.c4,-1,0,!1)
if(r!==-1){if(s!==-1&&r>s)b.l($.tI(),A.a([r,s],t.M),m)
if(r%4!==0)b.l($.tA(),A.a([r,4],t.M),m)
if(q===34963)b.n($.of(),m)}p=A.a_(a,"buffer",b,!0)
o=A.a6(a,"byteOffset",b,0,n,-1,0,!1)
A.O(a,"name",b,n,n,n,!1)
return new A.bH(p,o,s,r,q,A.w(a,B.aC,b,n),A.A(a,b),!1)},
bH:function bH(a,b,c,d,e,f,g,h){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ch=e
_.cy=_.cx=null
_.db=-1
_.a=f
_.b=g
_.a$=h},
uZ(a,b){var s,r=null,q="orthographic",p="perspective"
A.z(a,B.d7,b)
s=a.B(q)&&a.B(p)
if(s)b.F($.pd(),B.av)
switch(A.O(a,"type",b,r,B.av,r,!0)){case"orthographic":A.Y(a,q,b,A.xQ(),!0)
break
case"perspective":A.Y(a,p,b,A.xR(),!0)
break}A.O(a,"name",b,r,r,r,!1)
return new A.bI(A.w(a,B.dL,b,r),A.A(a,b),!1)},
uX(a,b){var s,r,q,p,o="xmag",n="ymag"
A.z(a,B.dd,b)
s=A.L(a,o,b,0/0,1/0,-1/0,1/0,-1/0,!0,0/0)
r=A.L(a,n,b,0/0,1/0,-1/0,1/0,-1/0,!0,0/0)
q=A.L(a,"zfar",b,0/0,1/0,0,1/0,-1/0,!0,0/0)
p=A.L(a,"znear",b,0/0,1/0,-1/0,1/0,0,!0,0/0)
if(q<=p)b.O($.pg())
if(s===0)b.n($.pf(),o)
else if(s<0)b.n($.pe(),o)
if(r===0)b.n($.pf(),n)
else if(r<0)b.n($.pe(),n)
return new A.cf(A.w(a,B.dJ,b,null),A.A(a,b),!1)},
uY(a,b){var s,r,q
A.z(a,B.cq,b)
s=A.L(a,"yfov",b,0/0,1/0,0,1/0,-1/0,!0,0/0)
if(s>=3.141592653589793)b.O($.tJ())
r=A.L(a,"zfar",b,0/0,1/0,0,1/0,-1/0,!1,0/0)
q=A.L(a,"znear",b,0/0,1/0,0,1/0,-1/0,!0,0/0)
if(r<=q)b.O($.pg())
A.L(a,"aspectRatio",b,0/0,1/0,0,1/0,-1/0,!1,0/0)
return new A.cg(A.w(a,B.dK,b,null),A.A(a,b),!1)},
bI:function bI(a,b,c){this.a=a
this.b=b
this.a$=c},
cf:function cf(a,b,c){this.a=a
this.b=b
this.a$=c},
cg:function cg(a,b,c){this.a=a
this.b=b
this.a$=c},
vf(c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6="extensionsRequired",b7="extensionsUsed",b8=null,b9=new A.jc(c1)
b9.$0()
A.z(c0,B.de,c1)
if(c0.B(b6)&&!c0.B(b7))c1.l($.d_(),A.a(["extensionsUsed"],t.M),b6)
s=A.r0(c0,b7,c1)
if(s==null)s=A.a([],t.i)
r=A.r0(c0,b6,c1)
if(r==null)r=A.a([],t.i)
c1.eu(s,r)
q=new A.jd(c0,b9,c1)
p=new A.je(b9,c0,c1).$1$3$req("asset",A.xJ(),!0,t.gP)
if((p==null?b8:p.f)==null)return b8
else if(p.gba()!==2){o=$.ud()
n=p.gba()
c1.l(o,A.a([n],t.M),"version")
return b8}else if(p.gbP()>0){o=$.ue()
n=p.gbP()
c1.l(o,A.a([n],t.M),"version")}m=q.$1$2("accessors",A.xG(),t.W)
l=q.$1$2("animations",A.xI(),t.bj)
k=q.$1$2("buffers",A.xO(),t.cT)
j=q.$1$2("bufferViews",A.xP(),t.n)
i=q.$1$2("cameras",A.xS(),t.h2)
h=q.$1$2("images",A.y6(),t.ec)
g=q.$1$2("materials",A.yx(),t.fC)
f=q.$1$2("meshes",A.yA(),t.eM)
o=t.L
e=q.$1$2("nodes",A.yB(),o)
d=q.$1$2("samplers",A.yD(),t.c2)
c=q.$1$2("scenes",A.yE(),t.J)
b9.$0()
b=A.a_(c0,"scene",c1,!1)
a=c.j(0,b)
n=b!==-1&&a==null
if(n)c1.l($.T(),A.a([b],t.M),"scene")
a0=q.$1$2("skins",A.yF(),t.aV)
a1=q.$1$2("textures",A.yH(),t.ai)
b9.$0()
a2=A.w(c0,B.T,c1,b8)
b9.$0()
a3=new A.dJ(s,r,m,l,p,k,j,i,h,g,f,e,d,a,a0,a1,a2,A.A(c0,c1),!1)
a4=new A.ja(c1,a3)
a4.$2(j,B.aC)
a4.$2(m,B.S)
a4.$2(h,B.aD)
a4.$2(a1,B.V)
a4.$2(g,B.f)
a4.$2(f,B.aF)
a4.$2(e,B.U)
a4.$2(a0,B.aJ)
a4.$2(l,B.aB)
a4.$2(c,B.aI)
if(a2.gP(a2)){n=c1.c
n.push("extensions")
a2.K(0,new A.j8(c1,a3))
n.pop()}n=c1.c
n.push("nodes")
e.a4(new A.j9(c1,A.aQ(o)))
n.pop()
a5=[m,k,j,i,h,g,f,e,d,a0,a1]
for(a6=0;a6<11;++a6){a7=a5[a6]
if(a7.gh(a7)===0)continue
n.push(a7.c)
for(o=a7.b,a8=a7.a,a9=a8.length,b0=0;b0<o;++b0){b1=b0>=a9
b1=b1?b8:a8[b0]
if((b1==null?b8:b1.a$)===!1)c1.X($.hG(),b0)}n.pop()}o=c1.y
if(o.gP(o)){for(a8=o.gM(),a8=a8.gD(a8);a8.p();){a9=a8.gt()
if(a9.gh(a9)===0)continue
b2=o.j(0,a9)
B.d.sh(n,0)
B.d.H(n,b2)
for(b1=a9.b,a9=a9.a,b3=a9.length,b0=0;b0<b1;++b0){b4=b0>=b3
b4=b4?b8:a9[b0]
if((b4==null?b8:b4.a$)===!1)c1.X($.hG(),b0)}}B.d.sh(n,0)}n.push("meshes")
for(o=f.b,a8=f.a,a9=a8.length,b0=0;b0<o;++b0){b1=b0>=a9
b5=b1?b8:a8[b0]
if((b5==null?b8:b5.y)!=null&&b5.a$&&!b5.z){n.push(B.c.k(b0))
c1.n($.tx(),"weights")
n.pop()}}B.d.sh(n,0)
return a3},
dJ:function dJ(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s){var _=this
_.d=a
_.e=b
_.f=c
_.r=d
_.x=e
_.y=f
_.z=g
_.Q=h
_.ch=i
_.cx=j
_.cy=k
_.db=l
_.dx=m
_.dy=n
_.fx=o
_.fy=p
_.a=q
_.b=r
_.a$=s},
jc:function jc(a){this.a=a},
jd:function jd(a,b,c){this.a=a
this.b=b
this.c=c},
je:function je(a,b,c){this.a=a
this.b=b
this.c=c},
ja:function ja(a,b){this.a=a
this.b=b},
jb:function jb(a,b){this.a=a
this.b=b},
j8:function j8(a,b){this.a=a
this.b=b},
j9:function j9(a,b){this.a=a
this.b=b},
j6:function j6(){},
j7:function j7(){},
jf:function jf(a,b){this.a=a
this.b=b},
jg:function jg(a,b){this.a=a
this.b=b},
r:function r(){},
p:function p(){},
fd:function fd(){},
hd:function hd(){},
vh(a,b){var s,r,q,p,o,n,m,l,k,j="bufferView",i=null,h="uri"
A.z(a,B.ct,b)
p=A.a_(a,j,b,!1)
o=A.O(a,"mimeType",b,i,b.k1,i,!1)
s=A.O(a,h,b,i,i,i,!1)
n=p===-1
m=!n
if(m&&o==null)b.l($.d_(),A.a(["mimeType"],t.M),j)
if(!(m&&s!=null))n=n&&s==null
else n=!0
if(n)b.F($.pd(),A.a(["bufferView","uri"],t.M))
r=null
if(s!=null){if(b.id)b.n($.p1(),h)
q=null
try{q=A.qc(s)}catch(l){if(A.X(l) instanceof A.bk)r=A.r2(s,b)
else throw l}if(q!=null){if(b.id)b.n($.p0(),h)
k=q.cI()
n=A.pJ(k)
n=n==null?i:B.cb[n.a]
n=n!==q.gbO().toLowerCase()
if(n){b.l($.pc(),A.a([s,"The declared mediatype does not match the embedded content."],t.M),h)
k=i}}else k=i}else k=i
n=r
A.O(a,"name",b,i,i,i,!1)
return new A.b1(p,o,n,k,A.w(a,B.aD,b,i),A.A(a,b),!1)},
b1:function b1(a,b,c,d,e,f,g){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.cx=_.ch=null
_.a=e
_.b=f
_.a$=g},
vG(a,b){var s,r,q,p,o,n,m,l,k,j,i=null,h="alphaCutoff"
A.z(a,B.cj,b)
s=A.Y(a,"pbrMetallicRoughness",b,A.yz(),!1)
r=A.Y(a,"normalTexture",b,A.r6(),!1)
q=A.Y(a,"occlusionTexture",b,A.yy(),!1)
p=A.Y(a,"emissiveTexture",b,A.az(),!1)
o=A.ag(a,"emissiveFactor",b,B.aj,B.l,1,0,!1)
n=A.O(a,"alphaMode",b,"OPAQUE",B.ci,i,!1)
A.L(a,h,b,0.5,1/0,-1/0,1/0,0,!1,0/0)
m=n!=="MASK"&&a.B(h)
if(m)b.n($.tT(),h)
l=A.qY(a,"doubleSided",b)
k=A.w(a,B.f,b,i)
A.O(a,"name",b,i,i,i,!1)
j=new A.aE(s,r,q,p,o,l,A.ai(t.X,t.e),k,A.A(a,b),!1)
m=A.a([s,r,q,p],t.M)
B.d.H(m,k.gU(k))
b.T(j,m)
return j},
vR(a,b){var s,r,q,p,o
A.z(a,B.cv,b)
A.ag(a,"baseColorFactor",b,B.ak,B.Q,1,0,!1)
s=A.Y(a,"baseColorTexture",b,A.az(),!1)
A.L(a,"metallicFactor",b,1,1/0,-1/0,1,0,!1,0/0)
A.L(a,"roughnessFactor",b,1,1/0,-1/0,1,0,!1,0/0)
r=A.Y(a,"metallicRoughnessTexture",b,A.az(),!1)
q=A.w(a,B.e5,b,null)
p=new A.cO(s,r,q,A.A(a,b),!1)
o=A.a([s,r],t.M)
B.d.H(o,q.gU(q))
b.T(p,o)
return p},
vQ(a,b){var s,r,q,p
A.z(a,B.cI,b)
s=A.w(a,B.aH,b,B.f)
r=A.a_(a,"index",b,!0)
q=A.a6(a,"texCoord",b,0,null,-1,0,!1)
A.L(a,"strength",b,1,1/0,-1/0,1,0,!1,0/0)
p=new A.cN(r,q,s,A.A(a,b),!1)
b.T(p,s.gU(s))
return p},
vP(a,b){var s,r,q,p
A.z(a,B.cH,b)
s=A.w(a,B.aG,b,B.f)
r=A.a_(a,"index",b,!0)
q=A.a6(a,"texCoord",b,0,null,-1,0,!1)
A.L(a,"scale",b,1,1/0,-1/0,1/0,-1/0,!1,0/0)
p=new A.cM(r,q,s,A.A(a,b),!1)
b.T(p,s.gU(s))
return p},
w8(a,b){var s,r
A.z(a,B.cG,b)
s=A.w(a,B.aK,b,B.f)
r=new A.bt(A.a_(a,"index",b,!0),A.a6(a,"texCoord",b,0,null,-1,0,!1),s,A.A(a,b),!1)
b.T(r,s.gU(s))
return r},
aE:function aE(a,b,c,d,e,f,g,h,i,j){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ch=e
_.db=f
_.dx=!1
_.dy=g
_.a=h
_.b=i
_.a$=j},
kx:function kx(a,b){this.a=a
this.b=b},
cO:function cO(a,b,c,d,e){var _=this
_.e=a
_.x=b
_.a=c
_.b=d
_.a$=e},
cN:function cN(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
cM:function cM(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
bt:function bt(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.f=null
_.a=c
_.b=d
_.a$=e},
dz(a){return new A.B(a.ch,a.z,a.cx)},
ce:function ce(a){this.a=a},
cb:function cb(a){this.a=a},
B:function B(a,b,c){this.a=a
this.b=b
this.c=c},
vK(a,b){var s,r,q,p,o,n,m,l,k,j,i=null,h="primitives"
A.z(a,B.cY,b)
s=A.ag(a,"weights",b,i,i,1/0,-1/0,!1)
r=A.eP(a,h,b)
if(r!=null){q=r.gh(r)
p=A.W(q,i,!1,t.ft)
o=new A.H(p,q,h,t.b_)
q=b.c
q.push(h)
for(n=0,m=0;m<r.gh(r);++m){q.push(B.c.k(m))
l=A.vJ(r.j(0,m),b)
k=l.x
j=k==null?i:k.length
if(j==null)j=0
if(m===0)n=j
else if(n!==j){k=$.tZ()
b.n(k,j>0?"targets":i)}p[m]=l
q.pop()}q.pop()
q=s!=null&&n!==s.length
if(q)b.l($.tU(),A.a([s.length,n],t.M),"weights")}else o=i
A.O(a,"name",b,i,i,i,!1)
return new A.b2(o,s,A.w(a,B.aF,b,i),A.A(a,b),!1)},
vI(a,b,c,d,e,f,g,h,i,j,k,l,m,n){var s,r=J.pL(l,t.e)
for(s=0;s<l;++s)r[s]=s
return new A.aJ(a,b,c,d,e,h,j,k,l,A.ai(t.X,t.W),r,m,n,!1)},
vJ(a,b){var s,r,q,p,o,n,m,l="attributes",k={}
A.z(a,B.cM,b)
k.a=k.b=k.c=!1
k.d=0
k.e=-1
k.f=0
k.r=-1
k.x=0
k.y=-1
k.z=0
k.Q=-1
s=A.a6(a,"mode",b,4,null,6,0,!1)
r=A.y1(a,l,b,new A.ky(k,b))
if(r!=null){q=b.c
q.push(l)
if(!k.c)b.O($.tX())
if(!k.b&&k.a)b.n($.tY(),"TANGENT")
p=new A.kz(b)
k.d=p.$3(k.e,k.d,"COLOR")
k.f=p.$3(k.r,k.f,"JOINTS")
k.x=p.$3(k.y,k.x,"WEIGHTS")
k.z=p.$3(k.Q,k.z,"TEXCOORD")
p=k.f
o=k.x
if(p!==o){b.F($.tW(),A.a([p,o],t.M))
k.x=k.f=0}q.pop()}n=A.y2(a,"targets",b,new A.kA(b))
m=A.vI(r,A.a_(a,"indices",b,!1),A.a_(a,"material",b,!1),s,n,k.c,k.b,k.a,k.d,k.f,k.x,k.z,A.w(a,B.aE,b,null),A.A(a,b))
k=m.a
b.T(m,k.gU(k))
return m},
b2:function b2(a,b,c,d,e){var _=this
_.x=a
_.y=b
_.z=!1
_.a=c
_.b=d
_.a$=e},
kH:function kH(a,b){this.a=a
this.b=b},
kG:function kG(a,b){this.a=a
this.b=b},
aJ:function aJ(a,b,c,d,e,f,g,h,i,j,k,l,m,n){var _=this
_.d=a
_.e=b
_.f=c
_.r=d
_.x=e
_.Q=f
_.cx=g
_.cy=h
_.db=i
_.dx=j
_.fr=_.dy=-1
_.go=_.fy=_.fx=null
_.id=k
_.a=l
_.b=m
_.a$=n},
ky:function ky(a,b){this.a=a
this.b=b},
kz:function kz(a){this.a=a},
kA:function kA(a){this.a=a},
kC:function kC(a,b,c){this.a=a
this.b=b
this.c=c},
kD:function kD(a,b){this.a=a
this.b=b},
kE:function kE(){},
kF:function kF(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
kB:function kB(){},
fg:function fg(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.x=d
_.ch=_.Q=0
_.cx=e
_.cy=f},
vO(b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=null,b1="matrix",b2="translation",b3="rotation"
A.z(b4,B.cc,b5)
if(b4.B(b1)){s=A.ag(b4,b1,b5,b0,B.c_,1/0,-1/0,!1)
if(s!=null){r=new Float32Array(16)
q=new A.da(r)
p=s[0]
o=s[1]
n=s[2]
m=s[3]
l=s[4]
k=s[5]
j=s[6]
i=s[7]
h=s[8]
g=s[9]
f=s[10]
e=s[11]
d=s[12]
c=s[13]
b=s[14]
r[15]=s[15]
r[14]=b
r[13]=c
r[12]=d
r[11]=e
r[10]=f
r[9]=g
r[8]=h
r[7]=i
r[6]=j
r[5]=k
r[4]=l
r[3]=m
r[2]=n
r[1]=o
r[0]=p}else q=b0}else q=b0
if(b4.B(b2)){a=A.ag(b4,b2,b5,b0,B.l,1/0,-1/0,!1)
a0=a!=null?A.qi(a):b0}else a0=b0
if(b4.B(b3)){a1=A.ag(b4,b3,b5,b0,B.Q,1,-1,!1)
if(a1!=null){r=a1[0]
p=a1[1]
o=a1[2]
n=a1[3]
m=new Float32Array(4)
a2=new A.fH(m)
m[0]=r
m[1]=p
m[2]=o
m[3]=n
r=Math.sqrt(a2.gaM())
if(Math.abs(1-r)>0.00769)b5.n($.ua(),b3)}else a2=b0}else a2=b0
if(b4.B("scale")){a3=A.ag(b4,"scale",b5,b0,B.l,1/0,-1/0,!1)
a4=a3!=null?A.qi(a3):b0}else a4=b0
a5=A.a_(b4,"camera",b5,!1)
a6=A.nP(b4,"children",b5,!1)
a7=A.a_(b4,"mesh",b5,!1)
a8=A.a_(b4,"skin",b5,!1)
a9=A.ag(b4,"weights",b5,b0,b0,1/0,-1/0,!1)
if(a7===-1){if(a8!==-1)b5.l($.d_(),A.a(["mesh"],t.M),"skin")
if(a9!=null)b5.l($.d_(),A.a(["mesh"],t.M),"weights")}if(q!=null){if(a0!=null||a2!=null||a4!=null)b5.n($.u3(),b1)
if(q.cU())b5.n($.u1(),b1)
else if(!A.yc(q))b5.n($.u4(),b1)}A.O(b4,"name",b5,b0,b0,b0,!1)
return new A.at(a5,a6,a8,q,a7,a0,a2,a4,a9,A.aQ(t.J),A.w(b4,B.U,b5,b0),A.A(b4,b5),!1)},
at:function at(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ch=e
_.cx=f
_.cy=g
_.db=h
_.dx=i
_.dy=j
_.id=_.go=_.fy=_.fx=_.fr=null
_.k1=!1
_.a=k
_.b=l
_.a$=m},
kL:function kL(){},
kM:function kM(){},
kN:function kN(a,b){this.a=a
this.b=b},
w3(a,b){var s=null
A.z(a,B.d_,b)
A.a6(a,"magFilter",b,-1,B.c9,-1,0,!1)
A.a6(a,"minFilter",b,-1,B.cd,-1,0,!1)
A.a6(a,"wrapS",b,10497,B.an,-1,0,!1)
A.a6(a,"wrapT",b,10497,B.an,-1,0,!1)
A.O(a,"name",b,s,s,s,!1)
return new A.bO(A.w(a,B.e6,b,s),A.A(a,b),!1)},
bO:function bO(a,b,c){this.a=a
this.b=b
this.a$=c},
w4(a,b){var s,r=null
A.z(a,B.cT,b)
s=A.nP(a,"nodes",b,!1)
A.O(a,"name",b,r,r,r,!1)
return new A.bP(s,A.w(a,B.aI,b,r),A.A(a,b),!1)},
bP:function bP(a,b,c,d){var _=this
_.x=a
_.y=null
_.a=b
_.b=c
_.a$=d},
kY:function kY(a,b){this.a=a
this.b=b},
w5(a,b){var s,r,q,p=null
A.z(a,B.cl,b)
s=A.a_(a,"inverseBindMatrices",b,!1)
r=A.a_(a,"skeleton",b,!1)
q=A.nP(a,"joints",b,!0)
A.O(a,"name",b,p,p,p,!1)
return new A.bQ(s,r,q,A.aQ(t.L),A.w(a,B.aJ,b,p),A.A(a,b),!1)},
bQ:function bQ(a,b,c,d,e,f,g){var _=this
_.x=a
_.y=b
_.z=c
_.cx=_.ch=_.Q=null
_.cy=d
_.a=e
_.b=f
_.a$=g},
m2:function m2(a){this.a=a},
ff:function ff(a){this.a=a},
w9(a,b){var s,r,q=null
A.z(a,B.d2,b)
s=A.a_(a,"sampler",b,!1)
r=A.a_(a,"source",b,!1)
A.O(a,"name",b,q,q,q,!1)
return new A.bT(s,r,A.w(a,B.V,b,q),A.A(a,b),!1)},
bT:function bT(a,b,c,d,e){var _=this
_.x=a
_.y=b
_.Q=_.z=null
_.a=c
_.b=d
_.a$=e},
qg(a){var s=a==null?0:a
return new A.ml(s,A.aQ(t.X))},
v6(){return new A.a8(B.as,new A.hX(),t.gw)},
v5(a){var s,r,q,p,o=t.i,n=A.a([],o),m=t._,l=A.a([],t.d6),k=A.ai(t.al,t.f9),j=A.a([],o),i=A.a([],o),h=A.a([],t.fh),g=A.a([],t.a9)
o=A.a(["image/jpeg","image/png"],o)
s=t.aD
r=t.X
q=t.cn
p=A.ou(["POSITION",A.aR([B.k],s),"NORMAL",A.aR([B.k],s),"TANGENT",A.aR([B.n],s),"TEXCOORD",A.aR([B.a3,B.a_,B.a2],s),"COLOR",A.aR([B.k,B.I,B.J,B.n,B.y,B.z],s),"JOINTS",A.aR([B.aZ,B.b_],s),"WEIGHTS",A.aR([B.n,B.y,B.z],s)],r,q)
q=A.ou(["POSITION",A.aR([B.k],s),"NORMAL",A.aR([B.k],s),"TANGENT",A.aR([B.k],s),"TEXCOORD",A.aR([B.a3,B.Z,B.a_,B.a1,B.a2],s),"COLOR",A.aR([B.k,B.w,B.I,B.x,B.J,B.n,B.K,B.y,B.L,B.z],s)],r,q)
s=a==null?A.qg(null):a
q=new A.i(s,n,A.ai(t.W,t.b7),A.ai(m,m),A.ai(t.f7,t.an),l,A.ai(t.n,t.gz),A.ai(t.b5,t.eG),k,j,i,h,A.aQ(t.af),g,new A.ab(""),o,p,q)
p=t.em
q.dx=new A.b7(i,p)
q.cy=new A.b7(j,p)
q.ch=new A.bw(k,t.f8)
q.fr=new A.b7(h,t.go)
return q},
ml:function ml(a,b){this.a=a
this.b=b},
i:function i(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r){var _=this
_.b=a
_.c=b
_.d=c
_.e=d
_.f=e
_.r=f
_.x=g
_.y=h
_.z=!1
_.Q=i
_.ch=null
_.cx=j
_.cy=null
_.db=k
_.dx=null
_.dy=l
_.fr=null
_.fx=m
_.fy=n
_.go=o
_.id=!1
_.k1=p
_.k2=q
_.k3=r},
hX:function hX(){},
hW:function hW(){},
hY:function hY(){},
hZ:function hZ(){},
i1:function i1(a){this.a=a},
i2:function i2(a){this.a=a},
i_:function i_(a){this.a=a},
i0:function i0(){},
i3:function i3(a,b){this.a=a
this.b=b},
cr:function cr(){},
vg(a){var s,r,q={}
q.a=q.b=null
s=new A.I($.F,t.dD)
r=new A.by(s,t.eP)
q.c=!1
q.a=a.b9(new A.ji(q,r),new A.jj(q),new A.jk(q,r))
return s},
pJ(a){var s,r
if(a.length<14)return null
s=A.kI(a.buffer,a.byteOffset,14)
r=s.getUint32(0,!0)
if((r&16777215)===16767231)return B.af
if(r===1196314761&&s.getUint32(4,!0)===169478669)return B.ag
if(r===1179011410&&s.getUint32(8,!0)===1346520407&&s.getUint16(12,!0)===20566)return B.ah
if(r===1481919403&&s.getUint32(4,!0)===3140497952&&s.getUint32(8,!0)===169478669)return B.bP
return null},
d5:function d5(a,b){this.a=a
this.b=b},
eg:function eg(a,b){this.a=a
this.b=b},
di:function di(a,b){this.a=a
this.b=b},
co:function co(a,b){this.a=a
this.b=b},
cq:function cq(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.x=h
_.y=i},
ji:function ji(a,b){this.a=a
this.b=b},
jk:function jk(a,b){this.a=a
this.b=b},
jj:function jj(a){this.a=a},
jh:function jh(){},
jt:function jt(a,b){var _=this
_.f=_.e=_.d=_.c=0
_.r=null
_.a=a
_.b=b},
jv:function jv(){},
ju:function ju(){},
kP:function kP(a,b,c,d,e,f){var _=this
_.y=_.x=_.r=_.f=_.e=_.d=_.c=0
_.Q=_.z=!1
_.ch=a
_.cx=b
_.cy=!1
_.db=c
_.dx=d
_.a=e
_.b=f},
kQ:function kQ(a){this.a=a},
mp:function mp(a,b,c){var _=this
_.c=a
_.d=0
_.a=b
_.b=c},
ec:function ec(){},
eb:function eb(){},
aO:function aO(a){this.a=a},
dp:function dp(a,b){this.a=a
this.b=b},
fJ:function fJ(a){var _=this
_.a=a
_.f=_.e=_.d=_.c=_.b=null},
kV:function kV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
kW:function kW(a,b,c){this.a=a
this.b=b
this.c=c},
kX:function kX(a,b){this.a=a
this.b=b},
nC(a){if(a==null)return null
if(a.ch==null||a.z===-1||a.Q===-1)return null
if(a.fr==null&&a.dx==null)return null
return a},
yM(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a
a0.f.a4(new A.o8(a1))
A.xr(a1)
s=A.a([],t.b2)
r=A.a([],t.bd)
q=a1.c
B.d.sh(q,0)
q.push("meshes")
for(p=a0.cy,o=p.b,n=a0.db,m=n.$ti.i("aq<o.E>"),l=a0.fx,p=p.a,k=p.length,j=0;j<o;++j){i={}
h=j>=k
g=h?null:p[j]
if((g==null?null:g.x)==null)continue
h=g.x
if(h.b6(h,new A.o9()))continue
i.a=i.b=-1
for(f=new A.aq(n,n.gh(n),m);f.p();){e=f.d
if(e.fy==g){d=e.id
d=(d==null?null:d.ch)!=null}else d=!1
if(d){e=e.id
c=e.ch.length
d=i.b
if(d===-1||c<d){i.b=c
i.a=l.bN(l,e)}}}if(i.b<1)continue
q.push(B.c.k(j))
q.push("primitives")
h.a4(new A.oa(i,a1,s,r))
q.pop()
q.pop()}q.pop()
if(s.length===0)return
for(;A.xy(s);)for(q=r.length,b=0;b<r.length;r.length===q||(0,A.cZ)(r),++b){a=r[b]
if(!a.x)a.eg(a1)}},
xy(a){var s,r
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.cZ)(a),++r)a[r].p()
if(!!a.fixed$length)A.a3(A.a1("removeWhere"))
B.d.e6(a,new A.nG(),!0)
return a.length!==0},
xr(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.d,s=s.gem(s),s=s.gD(s),r=a.c;s.p();){q=s.gt()
p=A.nC(q.a)
if(p==null)continue
o=B.m.j(0,p.ch)
if(o==null)o=0
n=q.b
B.d.sh(r,0)
for(q=p.ab(),q=new A.aL(q.a(),A.D(q).i("aL<1>")),m=J.S(n),l=0,k=0,j=!1;q.p();j=!0){i=q.gt()
for(h=0;h<m.gh(n);++h)if(!m.j(n,h).a_(a,l,k,i))continue;++k
if(k===o)k=0;++l}if(j)for(h=0;h<m.gh(n);++h)m.j(n,h).au(a)}},
o8:function o8(a){this.a=a},
o9:function o9(){},
oa:function oa(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
nG:function nG(){},
fi:function fi(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=0
_.x=!1
_.z=_.y=0
_.Q=f},
K(a,b,c){return new A.i7(c,a,b)},
ar(a,b,c){return new A.kZ(c,a,b)},
v(a,b,c){return new A.lf(c,a,b)},
y(a,b,c){return new A.jF(c,a,b)},
ap(a,b,c){return new A.iL(c,a,b)},
xs(a){return"'"+A.b(a)+"'"},
xn(a){return typeof a=="string"?"'"+a+"'":J.aZ(a)},
dd:function dd(a,b){this.a=a
this.b=b},
jn:function jn(){},
i7:function i7(a,b,c){this.a=a
this.b=b
this.c=c},
iw:function iw(){},
ix:function ix(){},
ip:function ip(){},
io:function io(){},
ic:function ic(){},
ib:function ib(){},
it:function it(){},
ij:function ij(){},
ia:function ia(){},
iq:function iq(){},
ih:function ih(){},
id:function id(){},
ig:function ig(){},
ie:function ie(){},
i8:function i8(){},
i9:function i9(){},
is:function is(){},
ir:function ir(){},
ii:function ii(){},
iz:function iz(){},
iB:function iB(){},
iE:function iE(){},
iF:function iF(){},
iC:function iC(){},
iD:function iD(){},
iA:function iA(){},
iG:function iG(){},
iy:function iy(){},
il:function il(){},
ik:function ik(){},
iu:function iu(){},
iv:function iv(){},
im:function im(){},
jl:function jl(a,b,c){this.a=a
this.b=b
this.c=c},
jm:function jm(){},
kZ:function kZ(a,b,c){this.a=a
this.b=b
this.c=c},
l0:function l0(){},
l1:function l1(){},
l_:function l_(){},
l3:function l3(){},
l4:function l4(){},
l5:function l5(){},
l2:function l2(){},
l6:function l6(){},
l7:function l7(){},
l8:function l8(){},
ld:function ld(){},
le:function le(){},
lc:function lc(){},
l9:function l9(){},
la:function la(){},
lb:function lb(){},
lf:function lf(a,b,c){this.a=a
this.b=b
this.c=c},
lZ:function lZ(){},
m_:function m_(){},
lK:function lK(){},
lu:function lu(){},
lh:function lh(){},
li:function li(){},
lg:function lg(){},
lj:function lj(){},
lk:function lk(){},
ll:function ll(){},
ln:function ln(){},
lm:function lm(){},
lo:function lo(){},
lp:function lp(){},
lq:function lq(){},
lr:function lr(){},
lC:function lC(){},
lF:function lF(){},
lJ:function lJ(){},
lH:function lH(){},
lE:function lE(){},
lI:function lI(){},
lG:function lG(){},
lD:function lD(){},
lO:function lO(){},
lM:function lM(){},
lP:function lP(){},
lW:function lW(){},
m1:function m1(){},
lV:function lV(){},
m0:function m0(){},
lt:function lt(){},
lN:function lN(){},
lS:function lS(){},
lR:function lR(){},
lQ:function lQ(){},
lX:function lX(){},
lY:function lY(){},
lU:function lU(){},
lL:function lL(){},
lT:function lT(){},
ls:function ls(){},
lv:function lv(){},
lw:function lw(){},
lB:function lB(){},
lA:function lA(){},
ly:function ly(){},
lx:function lx(){},
lz:function lz(){},
jF:function jF(a,b,c){this.a=a
this.b=b
this.c=c},
jI:function jI(){},
jG:function jG(){},
jH:function jH(){},
jJ:function jJ(){},
jM:function jM(){},
jK:function jK(){},
jL:function jL(){},
jQ:function jQ(){},
jO:function jO(){},
jS:function jS(){},
jP:function jP(){},
jR:function jR(){},
jN:function jN(){},
jT:function jT(){},
jW:function jW(){},
jV:function jV(){},
jU:function jU(){},
jX:function jX(){},
jY:function jY(){},
k1:function k1(){},
k2:function k2(){},
k8:function k8(){},
k0:function k0(){},
k_:function k_(){},
k5:function k5(){},
k4:function k4(){},
k3:function k3(){},
k9:function k9(){},
ka:function ka(){},
k7:function k7(){},
k6:function k6(){},
kb:function kb(){},
kc:function kc(){},
kf:function kf(){},
kd:function kd(){},
ke:function ke(){},
kg:function kg(){},
ki:function ki(){},
kh:function kh(){},
kj:function kj(){},
kk:function kk(){},
kl:function kl(){},
km:function km(){},
kn:function kn(){},
kq:function kq(){},
kp:function kp(){},
ko:function ko(){},
jZ:function jZ(){},
iL:function iL(a,b,c){this.a=a
this.b=b
this.c=c},
iS:function iS(){},
iT:function iT(){},
iV:function iV(){},
iM:function iM(){},
iU:function iU(){},
iN:function iN(){},
iQ:function iQ(){},
iP:function iP(){},
iO:function iO(){},
iY:function iY(){},
iX:function iX(){},
iZ:function iZ(){},
j_:function j_(){},
iW:function iW(){},
j0:function j0(){},
iR:function iR(){},
bJ:function bJ(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
x8(a){a.k1.push("image/webp")},
vc(a,b){b.toString
A.z(a,B.d3,b)
return new A.cm(A.a_(a,"source",b,!1),A.w(a,B.dN,b,null),A.A(a,b),!1)},
cm:function cm(a,b,c,d){var _=this
_.d=a
_.e=null
_.a=b
_.b=c
_.a$=d},
vo(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f="lights",e="spot"
b.toString
A.z(a,B.cP,b)
s=A.eP(a,f,b)
r=t.cp
if(s!=null){q=s.gh(s)
r=A.W(q,g,!1,r)
p=new A.H(r,q,f,t.E)
q=b.c
q.push(f)
for(o=t.h,n=0;n<s.gh(s);++n){m=s.j(0,n)
q.push(B.c.k(n))
A.z(m,B.cf,b)
A.ag(m,"color",b,B.D,B.l,1,0,!1)
A.L(m,"intensity",b,1,1/0,-1/0,1/0,0,!1,0/0)
l=A.O(m,"type",b,g,B.cy,g,!0)
if(l==="spot")A.Y(m,e,b,A.yg(),!0)
else{k=m.B(e)
if(k)b.n($.ph(),e)}j=A.L(m,"range",b,0/0,1/0,0,1/0,-1/0,!1,0/0)
k=l==="directional"&&!isNaN(j)
if(k)b.n($.ph(),"range")
A.O(m,"name",b,g,g,g,!1)
k=A.w(m,B.dQ,b,g)
i=m.j(0,"extras")
h=i!=null&&!o.b(i)
if(h)b.n($.dy(),"extras")
r[n]=new A.bp(k,i,!1)
q.pop()}q.pop()}else{r=J.bm(0,r)
p=new A.H(r,0,f,t.E)}return new A.bL(p,A.w(a,B.dO,b,g),A.A(a,b),!1)},
vp(a,b){var s,r,q="outerConeAngle"
A.z(a,B.cJ,b)
s=A.L(a,"innerConeAngle",b,0,1.5707963267948966,-1/0,1/0,0,!1,0/0)
r=A.L(a,q,b,0.7853981633974483,1/0,0,1.5707963267948966,-1/0,!1,0/0)
if(r<=s)b.l($.tM(),A.a([s,r],t.M),q)
return new A.cu(A.w(a,B.dP,b,null),A.A(a,b),!1)},
vq(a,b){b.toString
A.z(a,B.cO,b)
return new A.cv(A.a_(a,"light",b,!0),A.w(a,B.dR,b,null),A.A(a,b),!1)},
bL:function bL(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.a$=d},
jz:function jz(a,b){this.a=a
this.b=b},
bp:function bp(a,b,c){this.a=a
this.b=b
this.a$=c},
cu:function cu(a,b,c){this.a=a
this.b=b
this.a$=c},
cv:function cv(a,b,c,d){var _=this
_.d=a
_.e=null
_.a=b
_.b=c
_.a$=d},
vr(a,b){var s,r,q,p,o,n
b.toString
A.z(a,B.c3,b)
A.L(a,"clearcoatFactor",b,0,1/0,-1/0,1,0,!1,0/0)
s=A.Y(a,"clearcoatTexture",b,A.az(),!1)
A.L(a,"clearcoatRoughnessFactor",b,0,1/0,-1/0,1,0,!1,0/0)
r=A.Y(a,"clearcoatRoughnessTexture",b,A.az(),!1)
q=A.Y(a,"clearcoatNormalTexture",b,A.r6(),!1)
p=A.w(a,B.dS,b,null)
o=new A.cw(s,r,q,p,A.A(a,b),!1)
n=A.a([s,r,q],t.M)
B.d.H(n,p.gU(p))
b.T(o,n)
return o},
cw:function cw(a,b,c,d,e,f){var _=this
_.e=a
_.r=b
_.x=c
_.a=d
_.b=e
_.a$=f},
vs(a,b){b.toString
A.z(a,B.cz,b)
return new A.cx(A.L(a,"emissiveStrength",b,1,1/0,-1/0,1/0,0,!1,0/0),A.w(a,B.dT,b,null),A.A(a,b),!1)},
cx:function cx(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.a$=d},
vt(a,b){b.toString
A.z(a,B.cL,b)
A.L(a,"ior",b,1.5,1/0,-1/0,1/0,1,!1,0)
return new A.cy(A.w(a,B.dU,b,null),A.A(a,b),!1)},
cy:function cy(a,b,c){this.a=a
this.b=b
this.a$=c},
vu(a,b){var s,r,q,p,o,n,m,l="iridescenceThicknessMinimum",k="iridescenceThicknessMaximum",j="iridescenceThicknessTexture"
b.toString
A.z(a,B.d4,b)
A.L(a,"iridescenceFactor",b,0,1/0,-1/0,1,0,!1,0/0)
s=A.Y(a,"iridescenceTexture",b,A.az(),!1)
A.L(a,"iridescenceIor",b,1.3,1/0,-1/0,1/0,1,!1,0/0)
r=A.L(a,l,b,100,1/0,-1/0,1/0,0,!1,0/0)
q=A.L(a,k,b,400,1/0,-1/0,1/0,0,!1,0/0)
p=A.Y(a,j,b,A.az(),!1)
if(r>q){o=$.tO()
b.n(o,a.B(l)?l:k)}if(p!=null){if(r===q)b.n($.tQ(),j)}else if(!isNaN(r)&&a.B(l))b.n($.tP(),l)
n=A.w(a,B.dV,b,null)
m=new A.cz(s,p,n,A.A(a,b),!1)
o=A.a([s,p],t.M)
B.d.H(o,n.gU(n))
b.T(m,o)
return m},
cz:function cz(a,b,c,d,e){var _=this
_.e=a
_.y=b
_.a=c
_.b=d
_.a$=e},
vv(a,b){var s,r,q,p,o
b.toString
A.z(a,B.cx,b)
A.ag(a,"diffuseFactor",b,B.ak,B.Q,1,0,!1)
s=A.Y(a,"diffuseTexture",b,A.az(),!1)
A.ag(a,"specularFactor",b,B.D,B.l,1,0,!1)
A.L(a,"glossinessFactor",b,1,1/0,-1/0,1,0,!1,0/0)
r=A.Y(a,"specularGlossinessTexture",b,A.az(),!1)
q=A.w(a,B.dM,b,null)
p=new A.cA(s,r,q,A.A(a,b),!1)
o=A.a([s,r],t.M)
B.d.H(o,q.gU(q))
b.T(p,o)
return p},
cA:function cA(a,b,c,d,e){var _=this
_.e=a
_.x=b
_.a=c
_.b=d
_.a$=e},
vw(a,b){var s,r,q,p,o
b.toString
A.z(a,B.c2,b)
A.ag(a,"sheenColorFactor",b,B.aj,B.l,1,0,!1)
s=A.Y(a,"sheenColorTexture",b,A.az(),!1)
A.L(a,"sheenRoughnessFactor",b,0,1/0,-1/0,1,0,!1,0/0)
r=A.Y(a,"sheenRoughnessTexture",b,A.az(),!1)
q=A.w(a,B.dW,b,null)
p=new A.cB(s,r,q,A.A(a,b),!1)
o=A.a([s,r],t.M)
B.d.H(o,q.gU(q))
b.T(p,o)
return p},
cB:function cB(a,b,c,d,e){var _=this
_.e=a
_.r=b
_.a=c
_.b=d
_.a$=e},
vx(a,b){var s,r,q,p,o
b.toString
A.z(a,B.c5,b)
A.L(a,"specularFactor",b,1,1/0,-1/0,1,0,!1,0/0)
s=A.Y(a,"specularTexture",b,A.az(),!1)
A.ag(a,"specularColorFactor",b,B.D,B.l,1/0,0,!1)
r=A.Y(a,"specularColorTexture",b,A.az(),!1)
q=A.w(a,B.dX,b,null)
p=new A.cC(s,r,q,A.A(a,b),!1)
o=A.a([s,r],t.M)
B.d.H(o,q.gU(q))
b.T(p,o)
return p},
cC:function cC(a,b,c,d,e){var _=this
_.e=a
_.r=b
_.a=c
_.b=d
_.a$=e},
vy(a,b){var s,r,q,p
b.toString
A.z(a,B.c8,b)
A.L(a,"transmissionFactor",b,0,1/0,-1/0,1,0,!1,0/0)
s=A.Y(a,"transmissionTexture",b,A.az(),!1)
r=A.w(a,B.dY,b,null)
q=new A.cD(s,r,A.A(a,b),!1)
p=A.a([s],t.M)
B.d.H(p,r.gU(r))
b.T(q,p)
return q},
cD:function cD(a,b,c,d){var _=this
_.e=a
_.a=b
_.b=c
_.a$=d},
vz(a,b){b.toString
A.z(a,B.cA,b)
return new A.cE(A.w(a,B.dZ,b,null),A.A(a,b),!1)},
cE:function cE(a,b,c){this.a=a
this.b=b
this.a$=c},
vA(a,b){var s,r,q,p,o,n,m,l,k,j,i=null,h="variants"
b.toString
A.z(a,B.d9,b)
s=A.eP(a,h,b)
r=t.q
if(s!=null){q=s.gh(s)
r=A.W(q,i,!1,r)
p=new A.H(r,q,h,t.u)
q=b.c
q.push(h)
for(o=t.h,n=0;n<s.gh(s);++n){m=s.j(0,n)
q.push(B.c.k(n))
A.z(m,B.cR,b)
A.O(m,"name",b,i,i,i,!0)
l=A.w(m,B.e1,b,i)
k=m.j(0,"extras")
j=k!=null&&!o.b(k)
if(j)b.n($.dy(),"extras")
r[n]=new A.aP(l,k,!1)
q.pop()}q.pop()}else{r=J.bm(0,r)
p=new A.H(r,0,h,t.u)}return new A.bM(p,A.w(a,B.e_,b,i),A.A(a,b),!1)},
vB(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null,e="mappings"
b.toString
A.z(a,B.cQ,b)
s=A.eP(a,e,b)
r=t.aa
if(s!=null){q=s.gh(s)
r=A.W(q,f,!1,r)
p=new A.H(r,q,e,t.B)
q=b.c
q.push(e)
for(o=t.h,n=0;n<s.gh(s);++n){m=s.j(0,n)
q.push(B.c.k(n))
A.z(m,B.da,b)
l=A.nP(m,"variants",b,!0)
k=A.a_(m,"material",b,!0)
A.O(m,"name",b,f,f,f,!1)
j=A.w(m,B.e0,b,f)
i=m.j(0,"extras")
h=i!=null&&!o.b(i)
if(h)b.n($.dy(),"extras")
r[n]=new A.bq(l,k,j,i,!1)
q.pop()}q.pop()}else{r=J.bm(0,r)
p=new A.H(r,0,e,t.B)}g=new A.cF(p,A.w(a,B.e7,b,f),A.A(a,b),!1)
b.T(g,A.d8(p,!0,t._))
return g},
bM:function bM(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.a$=d},
jA:function jA(a,b){this.a=a
this.b=b},
aP:function aP(a,b,c){this.a=a
this.b=b
this.a$=c},
cF:function cF(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.a$=d},
jD:function jD(a,b,c){this.a=a
this.b=b
this.c=c},
bq:function bq(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.r=null
_.a=c
_.b=d
_.a$=e},
jB:function jB(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jC:function jC(a,b){this.a=a
this.b=b},
vC(a,b){var s,r,q,p,o
b.toString
A.z(a,B.dc,b)
A.ag(a,"attenuationColor",b,B.D,B.l,1,0,!1)
A.L(a,"attenuationDistance",b,0/0,1/0,0,1/0,-1/0,!1,0/0)
s=A.L(a,"thicknessFactor",b,0,1/0,-1/0,1/0,0,!1,0/0)
r=A.Y(a,"thicknessTexture",b,A.az(),!1)
q=A.w(a,B.e2,b,null)
p=new A.cG(s,r,q,A.A(a,b),!1)
o=A.a([r],t.M)
B.d.H(o,q.gU(q))
b.T(p,o)
return p},
cG:function cG(a,b,c,d,e){var _=this
_.f=a
_.r=b
_.a=c
_.b=d
_.a$=e},
jE:function jE(){},
vD(a,b){b.toString
A.z(a,B.cX,b)
A.ag(a,"offset",b,B.bZ,B.al,1/0,-1/0,!1)
A.L(a,"rotation",b,0,1/0,-1/0,1/0,-1/0,!1,0/0)
A.ag(a,"scale",b,B.c0,B.al,1/0,-1/0,!1)
return new A.cH(A.a6(a,"texCoord",b,-1,null,-1,0,!1),A.w(a,B.e3,b,null),A.A(a,b),!1)},
cH:function cH(a,b,c,d){var _=this
_.r=a
_.a=b
_.b=c
_.a$=d},
U:function U(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
Z:function Z(a,b,c){this.a=a
this.b=b
this.c=c},
cn:function cn(a,b){this.a=a
this.b=b},
cJ:function cJ(a,b){this.a=a
this.b=b},
fK:function fK(a,b){this.a=a
this.b=b},
fc:function fc(a,b,c){var _=this
_.a=a
_.b=null
_.c=b
_.d=null
_.e=c
_.f=null
_.cx=_.ch=_.Q=_.z=_.y=_.x=_.r=0
_.cy=!1
_.dy=_.dx=_.db=null
_.fr=!1
_.fx=null},
j3:function j3(a){this.a=a},
j4:function j4(a){this.a=a},
j1:function j1(a){this.a=a},
j2:function j2(a){this.a=a},
pI(a){return new A.fe(a)},
aI:function aI(a,b,c){this.a=a
this.b=b
this.c=c},
dK:function dK(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.e=_.d=null
_.f=!0},
j5:function j5(a){this.a=a},
fe:function fe(a){this.a=a},
aG(a,b,c,d){var s=a.j(0,b)
if(s==null&&a.B(b))d.l($.ac(),A.a([null,c],t.M),b)
return s},
nH(a){return typeof a=="number"&&Math.floor(a)===a?J.on(a):a},
a_(a,b,c,d){var s=A.nH(A.aG(a,b,"integer",c))
if(A.aX(s)){if(s>=0)return s
c.n($.hH(),b)}else if(s==null){if(d)c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([s,"integer"],t.M),b)
return-1},
qY(a,b,c){var s=A.aG(a,b,"boolean",c)
if(s==null)return!1
if(A.nD(s))return s
c.l($.ac(),A.a([s,"boolean"],t.M),b)
return!1},
a6(a,b,c,d,e,f,g,h){var s,r=A.nH(A.aG(a,b,"integer",c))
if(A.aX(r)){if(e!=null){if(!A.oQ(b,r,e,c,!1))return-1}else{if(!(r<g))s=f!==-1&&r>f
else s=!0
if(s){c.l($.oe(),A.a([r],t.M),b)
return-1}}return r}else if(r==null){if(!h)return d
c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([r,"integer"],t.M),b)
return-1},
L(a,b,c,d,e,f,g,h,i,j){var s,r=A.aG(a,b,"number",c)
if(typeof r=="number"){if(r!==j)s=r<h||r<=f||r>g||r>=e
else s=!1
if(s){c.l($.oe(),A.a([r],t.M),b)
return 0/0}return r}else if(r==null){if(!i)return d
c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([r,"number"],t.M),b)
return 0/0},
O(a,b,c,d,e,f,g){var s,r=A.aG(a,b,"string",c)
if(typeof r=="string"){if(e!=null)A.oQ(b,r,e,c,!1)
else{if(f==null)s=null
else{s=f.b
s=s.test(r)}if(s===!1){c.l($.ty(),A.a([r,f.a],t.M),b)
return null}}return r}else if(r==null){if(!g)return d
c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([r,"string"],t.M),b)
return null},
r2(a,b){var s,r,q,p
try{s=A.qd(a)
q=s
if(q.gcP()||q.gbJ()||q.gcO()||q.gbL()||q.gbK())b.l($.u8(),A.a([a],t.M),"uri")
return s}catch(p){q=A.X(p)
if(q instanceof A.bk){r=q
b.l($.pc(),A.a([a,r],t.M),"uri")
return null}else throw p}},
oS(a,b,c,d){var s=A.aG(a,b,"object",c)
if(t.t.b(s))return s
else if(s==null){if(d){c.F($.bD(),A.a([b],t.M))
return null}}else{c.l($.ac(),A.a([s,"object"],t.M),b)
if(d)return null}return A.ai(t.X,t._)},
Y(a,b,c,d,e){var s,r,q=A.aG(a,b,"object",c)
if(t.t.b(q)){s=c.c
s.push(b)
r=d.$2(q,c)
s.pop()
return r}else if(q==null){if(e)c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([q,"object"],t.M),b)
return null},
nP(a,b,c,d){var s,r,q,p,o,n,m=A.aG(a,b,"array",c)
if(t.m.b(m)){s=J.S(m)
if(s.gv(m)){c.n($.c7(),b)
return null}r=c.c
r.push(b)
q=t.e
p=A.aQ(q)
for(o=0;o<s.gh(m);++o){n=s.j(m,o)
if(typeof n=="number"&&Math.floor(n)===n)n=J.on(n)
if(A.aX(n)&&n>=0){if(!p.w(0,n))c.X($.pa(),o)
s.m(m,o,n)}else{s.m(m,o,-1)
c.X($.hH(),o)}}r.pop()
return s.af(m,q)}else if(m==null){if(d)c.F($.bD(),A.a([b],t.M))}else c.l($.ac(),A.a([m,"array"],t.M),b)
return null},
y1(a,b,c,d){var s,r=A.aG(a,b,"object",c)
if(t.t.b(r)){if(r.gv(r)){c.n($.c7(),b)
return null}s=c.c
s.push(b)
r.K(0,new A.nQ(d,r,c))
s.pop()
return r.ag(0,t.X,t.e)}else{s=t.M
if(r==null)c.F($.bD(),A.a([b],s))
else c.l($.ac(),A.a([r,"object"],s),b)}return null},
y2(a,b,c,d){var s,r,q,p,o,n,m,l=A.aG(a,b,"array",c)
if(t.m.b(l)){s=J.S(l)
if(s.gv(l)){c.n($.c7(),b)
return null}else{r=c.c
r.push(b)
for(q=t.M,p=t.t,o=!1,n=0;n<s.gh(l);++n){m=s.j(l,n)
if(p.b(m))if(m.gv(m)){c.X($.c7(),n)
o=!0}else{r.push(B.c.k(n))
m.K(0,new A.nR(d,m,c))
r.pop()}else{c.F($.eR(),A.a([m,"object"],q))
o=!0}}r.pop()
if(o)return null}s=J.pu(l,t.h)
r=A.D(s).i("a8<o.E,h<d*,f*>*>")
return A.d8(new A.a8(s,new A.nS(),r),!1,r.i("aj.E"))}else if(l!=null)c.l($.ac(),A.a([l,"array"],t.M),b)
return null},
ag(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m,l,k=null,j=A.aG(a,b,"array",c)
if(t.m.b(j)){s=J.S(j)
if(s.gv(j)){c.n($.c7(),b)
return k}if(e!=null&&!A.oQ(b,s.gh(j),e,c,!0))return k
r=A.W(s.gh(j),0,!1,t.F)
for(q=t.M,p=c.c,o=!1,n=0;n<s.gh(j);++n){m=s.j(j,n)
if(typeof m=="number"){l=m==1/0||m==-1/0||m<g||m>f
if(l){p.push(b)
c.an($.oe(),A.a([m],q),n)
p.pop()
o=!0}if(h){l=$.pn()
l[0]=m
r[n]=l[0]}else r[n]=m}else{c.l($.eR(),A.a([m,"number"],q),b)
o=!0}}if(o)return k
return r}else if(j==null){if(d==null)s=k
else s=J.d7(d.slice(0),A.a2(d).c)
return s}else c.l($.ac(),A.a([j,"array"],t.M),b)
return k},
qZ(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=A.aG(a,b,"array",c)
if(t.m.b(j)){s=J.S(j)
if(s.gh(j)!==e){c.l($.pb(),A.a([s.gh(j),A.a([e],t.V)],t.M),b)
return null}r=A.yL(d)
q=A.rd(d)
p=A.xW(d,e)
for(o=t.M,n=!1,m=0;m<s.gh(j);++m){l=s.j(j,m)
if(typeof l=="number"&&Math.floor(l)===l)l=J.on(l)
if(A.aX(l)){k=l<r||l>q
if(k){c.l($.tL(),A.a([l,B.ay.j(0,d)],o),b)
n=!0}p[m]=l}else{c.l($.eR(),A.a([l,"integer"],o),b)
n=!0}}if(n)return null
return p}else if(j!=null)c.l($.ac(),A.a([j,"array"],t.M),b)
return null},
r0(a,b,c){var s,r,q,p,o,n,m,l,k=A.aG(a,b,"array",c)
if(t.m.b(k)){s=J.S(k)
if(s.gv(k)){c.n($.c7(),b)
return null}r=c.c
r.push(b)
q=t.X
p=A.aQ(q)
for(o=t.M,n=!1,m=0;m<s.gh(k);++m){l=s.j(k,m)
if(typeof l=="string"){if(!p.w(0,l))c.X($.pa(),m)}else{c.an($.eR(),A.a([l,"string"],o),m)
n=!0}}r.pop()
if(n)return null
return s.af(k,q)}else if(k!=null)c.l($.ac(),A.a([k,"array"],t.M),b)
return null},
eP(a,b,c){var s,r,q,p,o,n,m=A.aG(a,b,"array",c)
if(t.m.b(m)){s=J.S(m)
if(s.gv(m)){c.n($.c7(),b)
return null}else{for(r=s.gD(m),q=t.t,p=t.M,o=!1;r.p();){n=r.gt()
if(!q.b(n)){c.l($.eR(),A.a([n,"object"],p),b)
o=!0}}if(o)return null}return s.af(m,q)}else{s=t.M
if(m==null)c.F($.bD(),A.a([b],s))
else c.l($.ac(),A.a([m,"array"],s),b)}return null},
w(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g="extensions",f=A.ai(t.X,t._),e=A.oS(a,g,c,!1)
if(e.gv(e))return f
s=c.c
s.push(g)
for(r=J.ah(e.gM()),q=t.ax,p=t.c,o=d==null,n=c.f,m=c.r;r.p();){l=r.gt()
k=A.oS(e,l,c,!1)
j=c.dx
if(!j.I(j,l)){j=c.cy
j=j.I(j,l)
if(!j)c.n($.tt(),l)
f.m(0,l,k)
continue}i=c.ch.a.j(0,new A.cn(b,l))
if(i==null){c.n($.tu(),l)
continue}if(e.gh(e)>1&&i.b)c.n($.u0(),l)
if(k!=null){s.push(l)
h=i.a.$2(k,c)
f.m(0,l,h)
if(!i.c&&p.b(h)){l=o?b:d
l=n.bT(l,new A.nO())
j=A.a(s.slice(0),A.a2(s))
j.fixed$length=Array
J.oj(l,new A.cJ(h,j))}if(q.b(h)){l=A.a(s.slice(0),A.a2(s))
l.fixed$length=Array
m.push(new A.fK(h,l))}s.pop()}}s.pop()
return f},
A(a,b){var s=a.j(0,"extras"),r=s!=null&&!t.h.b(s)
if(r)b.n($.dy(),"extras")
return s},
oQ(a,b,c,d,e){var s
if(!J.ok(c,b)){s=e?$.pb():$.tB()
d.l(s,A.a([b,c],t.M),a)
return!1}return!0},
z(a,b,c){var s,r,q
for(s=J.ah(a.gM());s.p();){r=s.gt()
if(!B.d.I(b,r)){q=B.d.I(B.cD,r)
q=!q}else q=!1
if(q)c.n($.tz(),r)}},
oV(a,b,c,d,e,f){var s,r,q,p,o,n,m=e.c
m.push(d)
for(s=t.M,r=c.a,q=r.length,p=0;p<a.gh(a);++p){o=a.j(0,p)
if(o===-1)continue
n=o==null||o<0||o>=q?null:r[o]
if(n!=null){n.a$=!0
b[p]=n
f.$3(n,o,p)}else e.an($.T(),A.a([o],s),p)}m.pop()},
yc(b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=b8.a
if(b7[3]!==0||b7[7]!==0||b7[11]!==0||b7[15]!==1)return!1
if(b8.cK()===0)return!1
s=$.uB()
r=$.uy()
q=$.uz()
p=$.pU
if(p==null)p=$.pU=new A.cR(new Float32Array(3))
p.bk(b7[0],b7[1],b7[2])
o=Math.sqrt(p.gaM())
p.bk(b7[4],b7[5],b7[6])
n=Math.sqrt(p.gaM())
p.bk(b7[8],b7[9],b7[10])
m=Math.sqrt(p.gaM())
if(b8.cK()<0)o=-o
s=s.a
s[0]=b7[12]
s[1]=b7[13]
s[2]=b7[14]
l=1/o
k=1/n
j=1/m
i=$.pS
if(i==null)i=$.pS=new A.da(new Float32Array(16))
h=i.a
h[15]=b7[15]
h[14]=b7[14]
h[13]=b7[13]
h[12]=b7[12]
h[11]=b7[11]
h[10]=b7[10]
h[9]=b7[9]
h[8]=b7[8]
h[7]=b7[7]
h[6]=b7[6]
h[5]=b7[5]
h[4]=b7[4]
h[3]=b7[3]
h[2]=b7[2]
h[1]=b7[1]
h[0]=b7[0]
h[0]=h[0]*l
h[1]=h[1]*l
h[2]=h[2]*l
h[4]=h[4]*k
h[5]=h[5]*k
h[6]=h[6]*k
h[8]=h[8]*j
h[9]=h[9]*j
h[10]=h[10]*j
g=$.pT
if(g==null)g=$.pT=new A.fo(new Float32Array(9))
f=g.a
f[0]=h[0]
f[1]=h[1]
f[2]=h[2]
f[3]=h[4]
f[4]=h[5]
f[5]=h[6]
f[6]=h[8]
f[7]=h[9]
f[8]=h[10]
r.toString
b7=f[0]
h=f[4]
e=f[8]
d=0+b7+h+e
if(d>0){c=Math.sqrt(d+1)
b7=r.a
b7[3]=c*0.5
c=0.5/c
b7[0]=(f[5]-f[7])*c
b7[1]=(f[6]-f[2])*c
b7[2]=(f[1]-f[3])*c}else{if(b7<h)b=h<e?2:1
else b=b7<e?2:0
a=(b+1)%3
a0=(b+2)%3
b7=b*3
h=a*3
e=a0*3
c=Math.sqrt(f[b7+b]-f[h+a]-f[e+a0]+1)
r=r.a
r[b]=c*0.5
c=0.5/c
r[3]=(f[h+a0]-f[e+a])*c
r[a]=(f[b7+a]+f[h+b])*c
r[a0]=(f[b7+a0]+f[e+b])*c
b7=r}q=q.a
q[0]=o
q[1]=n
q[2]=m
r=$.ux()
a1=b7[0]
a2=b7[1]
a3=b7[2]
a4=b7[3]
a5=a1+a1
a6=a2+a2
a7=a3+a3
a8=a1*a5
a9=a1*a6
b0=a1*a7
b1=a2*a6
b2=a2*a7
b3=a3*a7
b4=a4*a5
b5=a4*a6
b6=a4*a7
b7=r.a
b7[0]=1-(b1+b3)
b7[1]=a9+b6
b7[2]=b0-b5
b7[3]=0
b7[4]=a9-b6
b7[5]=1-(a8+b3)
b7[6]=b2+b4
b7[7]=0
b7[8]=b0+b5
b7[9]=b2-b4
b7[10]=1-(a8+b1)
b7[11]=0
b7[12]=s[0]
b7[13]=s[1]
b7[14]=s[2]
b7[15]=1
o=q[0]
n=q[1]
m=q[2]
b7[0]=b7[0]*o
b7[1]=b7[1]*o
b7[2]=b7[2]*o
b7[3]=b7[3]*o
b7[4]=b7[4]*n
b7[5]=b7[5]*n
b7[6]=b7[6]*n
b7[7]=b7[7]*n
b7[8]=b7[8]*m
b7[9]=b7[9]*m
b7[10]=b7[10]*m
b7[11]=b7[11]*m
b7[12]=b7[12]
b7[13]=b7[13]
b7[14]=b7[14]
b7[15]=b7[15]
return Math.abs(r.cQ()-b8.cQ())<0.00005},
xW(a,b){switch(a){case 5120:return new Int8Array(b)
case 5121:return new Uint8Array(b)
case 5122:return new Int16Array(b)
case 5123:return new Uint16Array(b)
case 5124:return new Int32Array(b)
case 5125:return new Uint32Array(b)
default:throw A.c(A.an(null,null))}},
nQ:function nQ(a,b,c){this.a=a
this.b=b
this.c=c},
nR:function nR(a,b,c){this.a=a
this.b=b
this.c=c},
nS:function nS(){},
nO:function nO(){},
H:function H(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
a7:function a7(){},
fS:function fS(a,b){this.a=0
this.b=a
this.c=b},
fT:function fT(a,b){this.a=0
this.b=a
this.c=b},
f1:function f1(a){this.a=a},
dg:function dg(a,b,c){this.a=a
this.b=b
this.c=c},
mo:function mo(a,b){this.a=a
this.b=b},
mn:function mn(){},
mm:function mm(){},
vH(){return new A.da(new Float32Array(16))},
w_(){return new A.fH(new Float32Array(4))},
qi(a){var s=new Float32Array(3)
s[2]=a[2]
s[1]=a[1]
s[0]=a[0]
return new A.cR(s)},
qh(){return new A.cR(new Float32Array(3))},
fo:function fo(a){this.a=a},
da:function da(a){this.a=a},
fH:function fH(a){this.a=a},
cR:function cR(a){this.a=a},
fX:function fX(a){this.a=a},
yv(){var s,r,q,p={}
p.a=0
s=$.eS()
r=J.eO(s)
q=r.gd1(s)
A.cU(q.a,q.b,new A.o_(p),!1)
q=r.gd3(s)
A.cU(q.a,q.b,new A.o0(),!1)
q=r.gd2(s)
A.cU(q.a,q.b,new A.o1(p),!1)
s=r.gd4(s)
A.cU(s.a,s.b,new A.o2(),!1)
s=J.uG($.uw())
A.cU(s.a,s.b,new A.o3(),!1)
s=$.oh()
s.toString
A.cU(s,"change",new A.o4(),!1)
A.hE("glTF Validator ver. 2.0.0-dev.3.8.")
A.hE("Supported extensions: "+A.v6().aj(0,", "))},
qP(a){var s
$.po().textContent=""
s=$.pq().style
s.display="none"
$.hI().textContent="Validating..."
s=J.ol($.eS())
s.at(0)
s.w(0,"drop")
A.hz(a).df(new A.nI(),t.P)},
hz(a){var s=0,r=A.hA(t.dC),q,p,o,n,m,l,k,j,i,h,g,f
var $async$hz=A.hC(function(b,c){if(b===1)return A.hv(c,r)
while(true)switch(s){case 0:f=$.pp()
f.d9(0)
f.c3(0)
p=A.v5(A.qg(16384))
f=a.length
n=null
m=0
while(!0){if(!(m<f)){o=null
break}l=a[m]
k=l.name.toLowerCase()
if(B.a.cM(k,".gltf")){o=new A.dK(A.oL(l),new A.by(new A.I($.F,t.f),t.j))
o.e=p
n=l
break}if(B.a.cM(k,".glb")){f=A.oL(l)
j=new Uint8Array(12)
o=new A.fc(j,f,new A.by(new A.I($.F,t.f),t.j))
p.id=!0
o.f=p
f=j.buffer
f=new DataView(f,0)
o.b=f
o.dy=new A.b8(null,null,null,null,t.f1)
n=l
break}++m
n=l}if(o==null){q=null
s=1
break}s=3
return A.dr(o.bU(),$async$hz)
case 3:i=c
s=(i==null?null:i.b)!=null?4:5
break
case 4:s=6
return A.dr(new A.kV(i.b,p,new A.nu(a,i),new A.nv(a)).aO(0),$async$hz)
case 6:case 5:h=new A.dg(A.qd(n.name),p,i)
f=$.pp()
if(f.b==null)f.b=$.e3.$0()
A.hE("Validation: "+f.gcL()+"ms.")
f.d9(0)
f.c3(0)
g=A.wm(h.bf(),null,"    ")
$.po().textContent=g
l=g.length
if(l<524288)$.uu().j(0,"Prism").cG("highlightAll",A.a([window.location.protocol!=="file:"],t.ff))
else A.hE("Report is too big: "+l+" bytes. Syntax highlighting disabled.")
if(f.b==null)f.b=$.e3.$0()
A.hE("Writing report: "+f.gcL()+"ms.")
q=h
s=1
break
case 1:return A.hw(q,r)}})
return A.hx($async$hz,r)},
qF(a,b){var s=b.gbR(b)
return(a&&B.ab).av(a,new A.nx(A.qy(s,0,s.length,B.N,!1)),new A.ny())},
oL(a){var s,r={}
r.a=!1
s=A.w6(new A.nA(r),t.Z)
s.d=new A.nB(r,s,a)
return new A.b9(s,A.D(s).i("b9<1>"))},
nw(a){var s=0,r=A.hA(t.Z),q,p,o,n
var $async$nw=A.hC(function(b,c){if(b===1)return A.hv(c,r)
while(true)switch(s){case 0:n=new FileReader()
n.readAsArrayBuffer(a)
p=new A.cT(n,"loadend",!1,t.cV)
s=3
return A.dr(p.gb7(p),$async$nw)
case 3:o=B.ac.gda(n)
if(t.Z.b(o)){q=o
s=1
break}q=null
s=1
break
case 1:return A.hw(q,r)}})
return A.hx($async$nw,r)},
o_:function o_(a){this.a=a},
o0:function o0(){},
o1:function o1(a){this.a=a},
o2:function o2(){},
o3:function o3(){},
o4:function o4(){},
nI:function nI(){},
nu:function nu(a,b){this.a=a
this.b=b},
nv:function nv(a){this.a=a},
nx:function nx(a){this.a=a},
ny:function ny(){},
nA:function nA(a){this.a=a},
nB:function nB(a,b,c){this.a=a
this.b=b
this.c=c},
nz:function nz(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
r4(a){return t.r.b(a)||t.A.b(a)||t.dz.b(a)||t.gb.b(a)||t.a0.b(a)||t.g4.b(a)||t.g2.b(a)},
yC(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof window=="object")return
if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
yJ(a){return A.a3(A.pO(a))},
qJ(a,b){if(a!==$)throw A.c(A.pO(b))},
x9(a){var s="POSITION",r="TEXCOORD",q=a.k2
q.j(0,s).H(0,B.d5)
q.j(0,"NORMAL").H(0,B.R)
q.j(0,"TANGENT").H(0,B.df)
q.j(0,r).H(0,B.c6)
q=a.k3
q.j(0,s).H(0,B.cm)
q.j(0,"NORMAL").H(0,B.R)
q.j(0,"TANGENT").H(0,B.R)
q.j(0,r).H(0,B.db)},
bb(a){switch(a){case 5120:case 5121:return 1
case 5122:case 5123:return 2
case 5124:case 5125:case 5126:return 4
default:return-1}},
yL(a){switch(a){case 5121:case 5123:case 5125:return 0
case 5120:return-128
case 5122:return-32768
case 5124:return-2147483648
default:throw A.c(A.an(null,null))}},
rd(a){switch(a){case 5120:return 127
case 5121:return 255
case 5122:return 32767
case 5123:return 65535
case 5124:return 2147483647
case 5125:return 4294967295
default:throw A.c(A.an(null,null))}},
hy(a,b){var s=a+b&536870911
s=s+((s&524287)<<10)&536870911
return s^s>>>6},
qD(a){var s=a+((a&67108863)<<3)&536870911
s^=s>>>11
return s+((s&16383)<<15)&536870911}},J={
oU(a,b,c,d){return{i:a,p:b,e:c,x:d}},
nT(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.oT==null){A.y8()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.c(A.qb("Return interceptor for "+A.b(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.mY
if(o==null)o=$.mY=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.yu(a)
if(p!=null)return p
if(typeof a=="function")return B.bW
s=Object.getPrototypeOf(a)
if(s==null)return B.aA
if(s===Object.prototype)return B.aA
if(typeof q=="function"){o=$.mY
if(o==null)o=$.mY=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.W,enumerable:false,writable:true,configurable:true})
return B.W}return B.W},
bm(a,b){if(a<0||a>4294967295)throw A.c(A.a0(a,0,4294967295,"length",null))
return J.d7(new Array(a),b)},
pL(a,b){if(a>4294967295)throw A.c(A.a0(a,0,4294967295,"length",null))
return J.d7(new Array(a),b)},
d7(a,b){return J.oq(A.a(a,b.i("E<0>")))},
oq(a){a.fixed$length=Array
return a},
pM(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
vk(a,b){var s,r
for(s=a.length;b<s;){r=B.a.E(a,b)
if(r!==32&&r!==13&&!J.pM(r))break;++b}return b},
or(a,b){var s,r
for(;b>0;b=s){s=b-1
r=B.a.A(a,s)
if(r!==32&&r!==13&&!J.pM(r))break}return b},
c4(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.dP.prototype
return J.fk.prototype}if(typeof a=="string")return J.bK.prototype
if(a==null)return J.dQ.prototype
if(typeof a=="boolean")return J.dO.prototype
if(a.constructor==Array)return J.E.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bn.prototype
return a}if(a instanceof A.e)return a
return J.nT(a)},
S(a){if(typeof a=="string")return J.bK.prototype
if(a==null)return a
if(a.constructor==Array)return J.E.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bn.prototype
return a}if(a instanceof A.e)return a
return J.nT(a)},
c5(a){if(a==null)return a
if(a.constructor==Array)return J.E.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bn.prototype
return a}if(a instanceof A.e)return a
return J.nT(a)},
y3(a){if(typeof a=="number")return J.cs.prototype
if(a==null)return a
if(!(a instanceof A.e))return J.bU.prototype
return a},
y4(a){if(typeof a=="number")return J.cs.prototype
if(typeof a=="string")return J.bK.prototype
if(a==null)return a
if(!(a instanceof A.e))return J.bU.prototype
return a},
hD(a){if(typeof a=="string")return J.bK.prototype
if(a==null)return a
if(!(a instanceof A.e))return J.bU.prototype
return a},
eO(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bn.prototype
return a}if(a instanceof A.e)return a
return J.nT(a)},
pr(a,b){if(typeof a=="number"&&typeof b=="number")return a+b
return J.y4(a).al(a,b)},
am(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.c4(a).N(a,b)},
ps(a,b){if(typeof b==="number")if(a.constructor==Array||typeof a=="string"||A.r5(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.S(a).j(a,b)},
uC(a,b,c){if(typeof b==="number")if((a.constructor==Array||A.r5(a,a[v.dispatchPropertyName]))&&!a.immutable$list&&b>>>0===b&&b<a.length)return a[b]=c
return J.c5(a).m(a,b,c)},
uD(a,b,c,d){return J.eO(a).dH(a,b,c,d)},
pt(a,b){return J.hD(a).E(a,b)},
uE(a,b,c,d){return J.eO(a).e5(a,b,c,d)},
oj(a,b){return J.c5(a).w(a,b)},
pu(a,b){return J.c5(a).af(a,b)},
ok(a,b){return J.S(a).I(a,b)},
eT(a,b){return J.c5(a).L(a,b)},
ol(a){return J.eO(a).gaH(a)},
d0(a){return J.c4(a).gC(a)},
om(a){return J.S(a).gv(a)},
uF(a){return J.S(a).gP(a)},
ah(a){return J.c5(a).gD(a)},
a9(a){return J.S(a).gh(a)},
uG(a){return J.eO(a).gd_(a)},
uH(a,b,c){return J.c5(a).aR(a,b,c)},
bc(a,b,c){return J.c5(a).ak(a,b,c)},
uI(a,b){return J.c4(a).bc(a,b)},
uJ(a,b){return J.S(a).sh(a,b)},
pv(a,b){return J.c5(a).a1(a,b)},
uK(a,b){return J.hD(a).V(a,b)},
on(a){return J.y3(a).eI(a)},
hJ(a,b){return J.c5(a).aP(a,b)},
aZ(a){return J.c4(a).k(a)},
pw(a){return J.hD(a).eM(a)},
uL(a){return J.hD(a).eN(a)},
dM:function dM(){},
dO:function dO(){},
dQ:function dQ(){},
aC:function aC(){},
cI:function cI(){},
fF:function fF(){},
bU:function bU(){},
bn:function bn(){},
E:function E(a){this.$ti=a},
js:function js(a){this.$ti=a},
bf:function bf(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
cs:function cs(){},
dP:function dP(){},
fk:function fk(){},
bK:function bK(){}},B={}
var w=[A,J,B]
hunkHelpers.setFunctionNamesIfNecessary(w)
var $={}
A.os.prototype={}
J.dM.prototype={
N(a,b){return a===b},
gC(a){return A.dc(a)},
k(a){return"Instance of '"+A.b(A.kT(a))+"'"},
bc(a,b){throw A.c(A.pX(a,b.gcX(),b.gd7(),b.gcZ()))}}
J.dO.prototype={
k(a){return String(a)},
gC(a){return a?519018:218159},
$iJ:1}
J.dQ.prototype={
N(a,b){return null==b},
k(a){return"null"},
gC(a){return 0},
bc(a,b){return this.dq(a,b)},
$im:1}
J.aC.prototype={}
J.cI.prototype={
gC(a){return 0},
k(a){return String(a)}}
J.fF.prototype={}
J.bU.prototype={}
J.bn.prototype={
k(a){var s=a[$.ob()]
if(s==null)return this.dz(a)
return"JavaScript function for "+A.b(J.aZ(s))},
$icp:1}
J.E.prototype={
af(a,b){return new A.bg(a,A.a2(a).i("@<1>").G(b).i("bg<1,2>"))},
w(a,b){if(!!a.fixed$length)A.a3(A.a1("add"))
a.push(b)},
e6(a,b,c){var s,r,q,p=[],o=a.length
for(s=0;s<o;++s){r=a[s]
if(!b.$1(r))p.push(r)
if(a.length!==o)throw A.c(A.aa(a))}q=p.length
if(q===o)return
this.sh(a,q)
for(s=0;s<p.length;++s)a[s]=p[s]},
H(a,b){var s
if(!!a.fixed$length)A.a3(A.a1("addAll"))
if(Array.isArray(b)){this.dG(a,b)
return}for(s=J.ah(b);s.p();)a.push(s.gt())},
dG(a,b){var s,r=b.length
if(r===0)return
if(a===b)throw A.c(A.aa(a))
for(s=0;s<r;++s)a.push(b[s])},
ak(a,b,c){return new A.a8(a,b,A.a2(a).i("@<1>").G(c).i("a8<1,2>"))},
aj(a,b){var s,r=A.W(a.length,"",!1,t.R)
for(s=0;s<a.length;++s)r[s]=A.b(a[s])
return r.join(b)},
a1(a,b){return A.ea(a,b,null,A.a2(a).c)},
av(a,b,c){var s,r,q=a.length
for(s=0;s<q;++s){r=a[s]
if(b.$1(r))return r
if(a.length!==q)throw A.c(A.aa(a))}return c.$0()},
L(a,b){return a[b]},
a2(a,b,c){if(b<0||b>a.length)throw A.c(A.a0(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.c(A.a0(c,b,a.length,"end",null))
if(b===c)return A.a([],A.a2(a))
return A.a(a.slice(b,c),A.a2(a))},
aR(a,b,c){A.aS(b,c,a.length)
return A.ea(a,b,c,A.a2(a).c)},
gaL(a){var s=a.length
if(s>0)return a[s-1]
throw A.c(A.jp())},
I(a,b){var s
for(s=0;s<a.length;++s)if(J.am(a[s],b))return!0
return!1},
gv(a){return a.length===0},
gP(a){return a.length!==0},
k(a){return A.jo(a,"[","]")},
aP(a,b){var s=J.d7(a.slice(0),A.a2(a).c)
return s},
bX(a){return A.vF(a,A.a2(a).c)},
gD(a){return new J.bf(a,a.length,A.a2(a).i("bf<1>"))},
gC(a){return A.dc(a)},
gh(a){return a.length},
sh(a,b){if(!!a.fixed$length)A.a3(A.a1("set length"))
if(b<0)throw A.c(A.a0(b,0,null,"newLength",null))
a.length=b},
j(a,b){if(!(b>=0&&b<a.length))throw A.c(A.eN(a,b))
return a[b]},
m(a,b,c){if(!!a.immutable$list)A.a3(A.a1("indexed set"))
if(!(b>=0&&b<a.length))throw A.c(A.eN(a,b))
a[b]=c},
$in:1,
$iq:1}
J.js.prototype={}
J.bf.prototype={
gt(){return this.d},
p(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.c(A.cZ(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iR:1}
J.cs.prototype={
eI(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.c(A.a1(""+a+".toInt()"))},
ep(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.c(A.a1(""+a+".floor()"))},
aq(a,b){var s,r,q,p
if(b<2||b>36)throw A.c(A.a0(b,2,36,"radix",null))
s=a.toString(b)
if(B.a.A(s,s.length-1)!==41)return s
r=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(r==null)A.a3(A.a1("Unexpected toString result: "+s))
s=r[1]
q=+r[3]
p=r[2]
if(p!=null){s+=p
q-=p.length}return s+B.a.bj("0",q)},
k(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gC(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
bi(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
as(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.cz(a,b)},
b3(a,b){return(a|0)===a?a/b|0:this.cz(a,b)},
cz(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.c(A.a1("Result of truncating division is "+A.b(s)+": "+A.b(a)+" ~/ "+b))},
aA(a,b){if(b<0)throw A.c(A.bA(b))
return b>31?0:a<<b>>>0},
ae(a,b){var s
if(a>0)s=this.cv(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
ea(a,b){if(0>b)throw A.c(A.bA(b))
return this.cv(a,b)},
cv(a,b){return b>31?0:a>>>b},
$iC:1,
$iQ:1}
J.dP.prototype={$if:1}
J.fk.prototype={}
J.bK.prototype={
A(a,b){if(b<0)throw A.c(A.eN(a,b))
if(b>=a.length)A.a3(A.eN(a,b))
return a.charCodeAt(b)},
E(a,b){if(b>=a.length)throw A.c(A.eN(a,b))
return a.charCodeAt(b)},
al(a,b){if(typeof b!="string")throw A.c(A.eX(b,null,null))
return a+b},
cM(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.aU(a,r-s)},
ay(a,b,c,d){var s=A.aS(b,c,a.length),r=a.substring(0,b),q=a.substring(s)
return r+d+q},
W(a,b,c){var s
if(c<0||c>a.length)throw A.c(A.a0(c,0,a.length,null,null))
s=c+b.length
if(s>a.length)return!1
return b===a.substring(c,s)},
V(a,b){return this.W(a,b,0)},
u(a,b,c){return a.substring(b,A.aS(b,c,a.length))},
aU(a,b){return this.u(a,b,null)},
eM(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(this.E(p,0)===133){s=J.vk(p,1)
if(s===o)return""}else s=0
r=o-1
q=this.A(p,r)===133?J.or(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
eN(a){var s,r,q
if(typeof a.trimRight!="undefined"){s=a.trimRight()
r=s.length
if(r===0)return s
q=r-1
if(this.A(s,q)===133)r=J.or(s,q)}else{r=J.or(a,a.length)
s=a}if(r===s.length)return s
if(r===0)return""
return s.substring(0,r)},
bj(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.c(B.bh)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
ap(a,b,c){var s=b-a.length
if(s<=0)return a
return this.bj(c,s)+a},
b8(a,b,c){var s
if(c<0||c>a.length)throw A.c(A.a0(c,0,a.length,null,null))
s=a.indexOf(b,c)
return s},
bN(a,b){return this.b8(a,b,0)},
k(a){return a},
gC(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gh(a){return a.length},
$id:1}
A.bW.prototype={
gD(a){var s=A.D(this)
return new A.dA(J.ah(this.ga7()),s.i("@<1>").G(s.Q[1]).i("dA<1,2>"))},
gh(a){return J.a9(this.ga7())},
gv(a){return J.om(this.ga7())},
gP(a){return J.uF(this.ga7())},
a1(a,b){var s=A.D(this)
return A.hU(J.pv(this.ga7(),b),s.c,s.Q[1])},
L(a,b){return J.eT(this.ga7(),b)},
I(a,b){return J.ok(this.ga7(),b)},
k(a){return J.aZ(this.ga7())}}
A.dA.prototype={
p(){return this.a.p()},
gt(){return this.a.gt()},
$iR:1}
A.ch.prototype={
ga7(){return this.a}}
A.ej.prototype={$in:1}
A.ef.prototype={
j(a,b){return J.ps(this.a,b)},
m(a,b,c){J.uC(this.a,b,c)},
sh(a,b){J.uJ(this.a,b)},
w(a,b){J.oj(this.a,b)},
aR(a,b,c){var s=this.$ti
return A.hU(J.uH(this.a,b,c),s.c,s.Q[1])},
$in:1,
$iq:1}
A.bg.prototype={
af(a,b){return new A.bg(this.a,this.$ti.i("@<1>").G(b).i("bg<1,2>"))},
ga7(){return this.a}}
A.ci.prototype={
ag(a,b,c){var s=this.$ti
return new A.ci(this.a,s.i("@<1>").G(s.Q[1]).G(b).G(c).i("ci<1,2,3,4>"))},
B(a){return this.a.B(a)},
j(a,b){return this.a.j(0,b)},
m(a,b,c){this.a.m(0,b,c)},
K(a,b){this.a.K(0,new A.hV(this,b))},
gM(){var s=this.$ti
return A.hU(this.a.gM(),s.c,s.Q[2])},
gh(a){var s=this.a
return s.gh(s)},
gv(a){var s=this.a
return s.gv(s)}}
A.hV.prototype={
$2(a,b){this.b.$2(a,b)},
$S(){return this.a.$ti.i("~(1,2)")}}
A.fn.prototype={
k(a){var s="LateInitializationError: "+this.a
return s}}
A.fI.prototype={
k(a){var s="ReachabilityError: "+this.a
return s}}
A.d2.prototype={
gh(a){return this.a.length},
j(a,b){return B.a.A(this.a,b)}}
A.o6.prototype={
$0(){var s=new A.I($.F,t.ck)
s.ad(null)
return s},
$S:48}
A.e1.prototype={
k(a){return"Null is not a valid value for '"+this.a+"' of type '"+A.qV(this.$ti.c).k(0)+"'"},
$ib6:1}
A.n.prototype={}
A.aj.prototype={
gD(a){var s=this
return new A.aq(s,s.gh(s),A.D(s).i("aq<aj.E>"))},
gv(a){return this.gh(this)===0},
I(a,b){var s,r=this,q=r.gh(r)
for(s=0;s<q;++s){if(J.am(r.L(0,s),b))return!0
if(q!==r.gh(r))throw A.c(A.aa(r))}return!1},
aj(a,b){var s,r,q,p=this,o=p.gh(p)
if(b.length!==0){if(o===0)return""
s=A.b(p.L(0,0))
if(o!==p.gh(p))throw A.c(A.aa(p))
for(r=s,q=1;q<o;++q){r=r+b+A.b(p.L(0,q))
if(o!==p.gh(p))throw A.c(A.aa(p))}return r.charCodeAt(0)==0?r:r}else{for(q=0,r="";q<o;++q){r+=A.b(p.L(0,q))
if(o!==p.gh(p))throw A.c(A.aa(p))}return r.charCodeAt(0)==0?r:r}},
ak(a,b,c){return new A.a8(this,b,A.D(this).i("@<aj.E>").G(c).i("a8<1,2>"))},
a1(a,b){return A.ea(this,b,null,A.D(this).i("aj.E"))}}
A.e9.prototype={
gdO(){var s=J.a9(this.a),r=this.c
if(r==null||r>s)return s
return r},
geb(){var s=J.a9(this.a),r=this.b
if(r>s)return s
return r},
gh(a){var s,r=J.a9(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
L(a,b){var s=this,r=s.geb()+b
if(b<0||r>=s.gdO())throw A.c(A.d6(b,s,"index",null,null))
return J.eT(s.a,r)},
a1(a,b){var s,r,q=this
A.b4(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.bj(q.$ti.i("bj<1>"))
return A.ea(q.a,s,r,q.$ti.c)},
aP(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.S(n),l=m.gh(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=J.bm(0,p.$ti.c)
return n}r=A.W(s,m.L(n,o),!1,p.$ti.c)
for(q=1;q<s;++q){r[q]=m.L(n,o+q)
if(m.gh(n)<l)throw A.c(A.aa(p))}return r}}
A.aq.prototype={
gt(){return this.d},
p(){var s,r=this,q=r.a,p=J.S(q),o=p.gh(q)
if(r.b!==o)throw A.c(A.aa(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.L(q,s);++r.c
return!0},
$iR:1}
A.br.prototype={
gD(a){var s=A.D(this)
return new A.dZ(J.ah(this.a),this.b,s.i("@<1>").G(s.Q[1]).i("dZ<1,2>"))},
gh(a){return J.a9(this.a)},
gv(a){return J.om(this.a)},
L(a,b){return this.b.$1(J.eT(this.a,b))}}
A.bi.prototype={$in:1}
A.dZ.prototype={
p(){var s=this,r=s.b
if(r.p()){s.a=s.c.$1(r.gt())
return!0}s.a=null
return!1},
gt(){return this.a}}
A.a8.prototype={
gh(a){return J.a9(this.a)},
L(a,b){return this.b.$1(J.eT(this.a,b))}}
A.ed.prototype={
gD(a){return new A.cS(J.ah(this.a),this.b,this.$ti.i("cS<1>"))},
ak(a,b,c){return new A.br(this,b,this.$ti.i("@<1>").G(c).i("br<1,2>"))}}
A.cS.prototype={
p(){var s,r
for(s=this.a,r=this.b;s.p();)if(r.$1(s.gt()))return!0
return!1},
gt(){return this.a.gt()}}
A.bs.prototype={
a1(a,b){A.hM(b,"count")
A.b4(b,"count")
return new A.bs(this.a,this.b+b,A.D(this).i("bs<1>"))},
gD(a){return new A.e7(J.ah(this.a),this.b,A.D(this).i("e7<1>"))}}
A.d4.prototype={
gh(a){var s=J.a9(this.a)-this.b
if(s>=0)return s
return 0},
a1(a,b){A.hM(b,"count")
A.b4(b,"count")
return new A.d4(this.a,this.b+b,this.$ti)},
$in:1}
A.e7.prototype={
p(){var s,r
for(s=this.a,r=0;r<this.b;++r)s.p()
this.b=0
return s.p()},
gt(){return this.a.gt()}}
A.bj.prototype={
gD(a){return B.b8},
gv(a){return!0},
gh(a){return 0},
L(a,b){throw A.c(A.a0(b,0,0,"index",null))},
I(a,b){return!1},
ak(a,b,c){return new A.bj(c.i("bj<0>"))},
a1(a,b){A.b4(b,"count")
return this}}
A.dE.prototype={
p(){return!1},
gt(){throw A.c(A.jp())},
$iR:1}
A.dH.prototype={
sh(a,b){throw A.c(A.a1("Cannot change the length of a fixed-length list"))},
w(a,b){throw A.c(A.a1("Cannot add to a fixed-length list"))}}
A.fV.prototype={
m(a,b,c){throw A.c(A.a1("Cannot modify an unmodifiable list"))},
sh(a,b){throw A.c(A.a1("Cannot change the length of an unmodifiable list"))},
w(a,b){throw A.c(A.a1("Cannot add to an unmodifiable list"))}}
A.df.prototype={}
A.de.prototype={
gC(a){var s=this._hashCode
if(s!=null)return s
s=664597*J.d0(this.a)&536870911
this._hashCode=s
return s},
k(a){return'Symbol("'+A.b(this.a)+'")'},
N(a,b){if(b==null)return!1
return b instanceof A.de&&this.a==b.a},
$icQ:1}
A.eG.prototype={}
A.dB.prototype={}
A.d3.prototype={
ag(a,b,c){var s=A.D(this)
return A.pR(this,s.c,s.Q[1],b,c)},
gv(a){return this.gh(this)===0},
k(a){return A.ow(this)},
m(a,b,c){A.v4()
A.b5(u.g)},
$ih:1}
A.aA.prototype={
gh(a){return this.a},
B(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.b.hasOwnProperty(a)},
j(a,b){if(!this.B(b))return null
return this.b[b]},
K(a,b){var s,r,q,p,o=this.c
for(s=o.length,r=this.b,q=0;q<s;++q){p=o[q]
b.$2(p,r[p])}},
gM(){return new A.eh(this,this.$ti.i("eh<1>"))}}
A.eh.prototype={
gD(a){var s=this.a.c
return new J.bf(s,s.length,A.a2(s).i("bf<1>"))},
gh(a){return this.a.c.length}}
A.a5.prototype={
aD(){var s,r,q=this,p=q.$map
if(p==null){s=q.$ti
r=A.ve(s.i("1?"))
p=A.vE(A.xl(),r,s.c,s.Q[1])
A.qX(q.a,p)
q.$map=p}return p},
B(a){return this.aD().B(a)},
j(a,b){return this.aD().j(0,b)},
K(a,b){this.aD().K(0,b)},
gM(){return this.aD().gM()},
gh(a){var s=this.aD()
return s.gh(s)}}
A.iK.prototype={
$1(a){return this.a.b(a)},
$S:14}
A.jq.prototype={
gcX(){var s=this.a
return s},
gd7(){var s,r,q,p,o=this
if(o.c===1)return B.at
s=o.d
r=s.length-o.e.length-o.f
if(r===0)return B.at
q=[]
for(p=0;p<r;++p)q.push(s[p])
q.fixed$length=Array
q.immutable$list=Array
return q},
gcZ(){var s,r,q,p,o,n,m=this
if(m.c!==0)return B.az
s=m.e
r=s.length
q=m.d
p=q.length-r-m.f
if(r===0)return B.az
o=new A.aD(t.eo)
for(n=0;n<r;++n)o.m(0,new A.de(s[n]),q[p+n])
return new A.dB(o,t.gF)}}
A.kS.prototype={
$0(){return B.C.ep(1000*this.a.now())},
$S:15}
A.kR.prototype={
$2(a,b){var s=this.a
s.b=s.b+"$"+A.b(a)
this.b.push(a)
this.c.push(b);++s.a},
$S:96}
A.ma.prototype={
a6(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.e2.prototype={
k(a){var s=this.b
if(s==null)return"NoSuchMethodError: "+A.b(this.a)
return"NoSuchMethodError: method not found: '"+s+"' on null"}}
A.fl.prototype={
k(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+A.b(r.a)
s=r.c
if(s==null)return q+p+"' ("+A.b(r.a)+")"
return q+p+"' on '"+s+"' ("+A.b(r.a)+")"}}
A.fU.prototype={
k(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.fD.prototype={
k(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"},
$iao:1}
A.dF.prototype={}
A.et.prototype={
k(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iaU:1}
A.cj.prototype={
k(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.re(r==null?"unknown":r)+"'"},
$icp:1,
geR(){return this},
$C:"$1",
$R:1,
$D:null}
A.f2.prototype={$C:"$0",$R:0}
A.f3.prototype={$C:"$2",$R:2}
A.fQ.prototype={}
A.fN.prototype={
k(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.re(s)+"'"}}
A.d1.prototype={
N(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.d1))return!1
return this.$_target===b.$_target&&this.a===b.a},
gC(a){return(A.o7(this.a)^A.dc(this.$_target))>>>0},
k(a){return"Closure '"+A.b(this.$_name)+"' of "+("Instance of '"+A.b(A.kT(this.a))+"'")}}
A.fL.prototype={
k(a){return"RuntimeError: "+this.a}}
A.n9.prototype={}
A.aD.prototype={
gh(a){return this.a},
gv(a){return this.a===0},
gP(a){return!this.gv(this)},
gM(){return new A.dU(this,A.D(this).i("dU<1>"))},
gU(a){var s=A.D(this)
return A.kw(this.gM(),new A.jw(this),s.c,s.Q[1])},
B(a){var s,r,q=this
if(typeof a=="string"){s=q.b
if(s==null)return!1
return q.cj(s,a)}else if(typeof a=="number"&&(a&0x3ffffff)===a){r=q.c
if(r==null)return!1
return q.cj(r,a)}else return q.cR(a)},
cR(a){var s=this,r=s.d
if(r==null)return!1
return s.aK(s.bA(r,s.aJ(a)),a)>=0},
j(a,b){var s,r,q,p,o=this,n=null
if(typeof b=="string"){s=o.b
if(s==null)return n
r=o.aW(s,b)
q=r==null?n:r.b
return q}else if(typeof b=="number"&&(b&0x3ffffff)===b){p=o.c
if(p==null)return n
r=o.aW(p,b)
q=r==null?n:r.b
return q}else return o.cS(b)},
cS(a){var s,r,q=this,p=q.d
if(p==null)return null
s=q.bA(p,q.aJ(a))
r=q.aK(s,a)
if(r<0)return null
return s[r].b},
m(a,b,c){var s,r,q=this
if(typeof b=="string"){s=q.b
q.c5(s==null?q.b=q.bD():s,b,c)}else if(typeof b=="number"&&(b&0x3ffffff)===b){r=q.c
q.c5(r==null?q.c=q.bD():r,b,c)}else q.cT(b,c)},
cT(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=p.bD()
s=p.aJ(a)
r=p.bA(o,s)
if(r==null)p.bG(o,s,[p.bE(a,b)])
else{q=p.aK(r,a)
if(q>=0)r[q].b=b
else r.push(p.bE(a,b))}},
bT(a,b){var s
if(this.B(a))return this.j(0,a)
s=b.$0()
this.m(0,a,s)
return s},
K(a,b){var s=this,r=s.e,q=s.r
for(;r!=null;){b.$2(r.a,r.b)
if(q!==s.r)throw A.c(A.aa(s))
r=r.c}},
c5(a,b,c){var s=this.aW(a,b)
if(s==null)this.bG(a,b,this.bE(b,c))
else s.b=c},
bE(a,b){var s=this,r=new A.kr(a,b)
if(s.e==null)s.e=s.f=r
else s.f=s.f.c=r;++s.a
s.r=s.r+1&67108863
return r},
aJ(a){return J.d0(a)&0x3ffffff},
aK(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.am(a[r].a,b))return r
return-1},
k(a){return A.ow(this)},
aW(a,b){return a[b]},
bA(a,b){return a[b]},
bG(a,b,c){a[b]=c},
dN(a,b){delete a[b]},
cj(a,b){return this.aW(a,b)!=null},
bD(){var s="<non-identifier-key>",r=Object.create(null)
this.bG(r,s,r)
this.dN(r,s)
return r}}
A.jw.prototype={
$1(a){return this.a.j(0,a)},
$S(){return A.D(this.a).i("2(1)")}}
A.kr.prototype={}
A.dU.prototype={
gh(a){return this.a.a},
gv(a){return this.a.a===0},
gD(a){var s=this.a,r=new A.dV(s,s.r,this.$ti.i("dV<1>"))
r.c=s.e
return r},
I(a,b){return this.a.B(b)}}
A.dV.prototype={
gt(){return this.d},
p(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.c(A.aa(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iR:1}
A.nV.prototype={
$1(a){return this.a(a)},
$S:4}
A.nW.prototype={
$2(a,b){return this.a(a,b)},
$S:58}
A.nX.prototype={
$1(a){return this.a(a)},
$S:88}
A.jr.prototype={
k(a){return"RegExp/"+this.a+"/"+this.b.flags},
aI(a){var s
if(typeof a!="string")A.a3(A.bA(a))
s=this.b.exec(a)
if(s==null)return null
return new A.n7(s)}}
A.n7.prototype={}
A.ft.prototype={$ipE:1}
A.cK.prototype={
dY(a,b,c,d){var s=A.a0(b,0,c,d,null)
throw A.c(s)},
cd(a,b,c,d){if(b>>>0!==b||b>c)this.dY(a,b,c,d)},
$iav:1}
A.db.prototype={
gh(a){return a.length},
e9(a,b,c,d,e){var s,r,q=a.length
this.cd(a,b,q,"start")
this.cd(a,c,q,"end")
if(b>c)throw A.c(A.a0(b,0,c,null,null))
s=c-b
if(e<0)throw A.c(A.an(e,null))
r=d.length
if(r-e<s)throw A.c(A.bS("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iae:1}
A.e_.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
m(a,b,c){A.bz(b,a,a.length)
a[b]=c},
$in:1,
$iq:1}
A.aF.prototype={
m(a,b,c){A.bz(b,a,a.length)
a[b]=c},
a5(a,b,c,d,e){if(t.eB.b(d)){this.e9(a,b,c,d,e)
return}this.dA(a,b,c,d,e)},
dn(a,b,c,d){return this.a5(a,b,c,d,0)},
$in:1,
$iq:1}
A.fu.prototype={
a2(a,b,c){return new Float32Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fv.prototype={
a2(a,b,c){return new Float64Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fw.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Int16Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fx.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Int32Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fy.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Int8Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fz.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Uint16Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.fA.prototype={
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Uint32Array(a.subarray(b,A.c1(b,c,a.length)))}}
A.e0.prototype={
gh(a){return a.length},
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Uint8ClampedArray(a.subarray(b,A.c1(b,c,a.length)))}}
A.cL.prototype={
gh(a){return a.length},
j(a,b){A.bz(b,a,a.length)
return a[b]},
a2(a,b,c){return new Uint8Array(a.subarray(b,A.c1(b,c,a.length)))},
$icL:1,
$iaw:1}
A.eo.prototype={}
A.ep.prototype={}
A.eq.prototype={}
A.er.prototype={}
A.aT.prototype={
i(a){return A.nh(v.typeUniverse,this,a)},
G(a){return A.wD(v.typeUniverse,this,a)}}
A.hc.prototype={}
A.ey.prototype={
k(a){return A.aH(this.a,null)},
$ibu:1}
A.h7.prototype={
k(a){return this.a}}
A.ez.prototype={$ib6:1}
A.mB.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:16}
A.mA.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:56}
A.mC.prototype={
$0(){this.a.$0()},
$S:2}
A.mD.prototype={
$0(){this.a.$0()},
$S:2}
A.nf.prototype={
dE(a,b){if(self.setTimeout!=null)self.setTimeout(A.eM(new A.ng(this,b),0),a)
else throw A.c(A.a1("`setTimeout()` not found."))}}
A.ng.prototype={
$0(){this.b.$0()},
$S:1}
A.h_.prototype={
ai(a,b){var s,r=this
if(!r.b)r.a.ad(b)
else{s=r.a
if(r.$ti.i("aB<1>").b(b))s.ca(b)
else s.bt(b)}},
bI(a,b){var s
if(b==null)b=A.hP(a)
s=this.a
if(this.b)s.am(a,b)
else s.bm(a,b)}}
A.nl.prototype={
$1(a){return this.a.$2(0,a)},
$S:17}
A.nm.prototype={
$2(a,b){this.a.$2(1,new A.dF(a,b))},
$S:34}
A.nJ.prototype={
$2(a,b){this.a(a,b)},
$S:37}
A.dl.prototype={
k(a){return"IterationMarker("+this.b+", "+A.b(this.a)+")"}}
A.aL.prototype={
gt(){var s=this.c
if(s==null)return this.b
return s.gt()},
p(){var s,r,q,p,o,n=this
for(;!0;){s=n.c
if(s!=null)if(s.p())return!0
else n.c=null
r=function(a,b,c){var m,l=b
while(true)try{return a(l,m)}catch(k){m=k
l=c}}(n.a,0,1)
if(r instanceof A.dl){q=r.b
if(q===2){p=n.d
if(p==null||p.length===0){n.b=null
return!1}n.a=p.pop()
continue}else{s=r.a
if(q===3)throw s
else{o=J.ah(s)
if(o instanceof A.aL){s=n.d
if(s==null)s=n.d=[]
s.push(n.a)
n.a=o.a
continue}else{n.c=o
continue}}}}else{n.b=r
return!0}}return!1},
$iR:1}
A.ex.prototype={
gD(a){return new A.aL(this.a(),this.$ti.i("aL<1>"))}}
A.eZ.prototype={
k(a){return A.b(this.a)},
$iG:1,
gaT(){return this.b}}
A.h2.prototype={
bI(a,b){var s
A.cX(a,"error",t.K)
s=this.a
if((s.a&30)!==0)throw A.c(A.bS("Future already completed"))
if(b==null)b=A.hP(a)
s.bm(a,b)},
Y(a){return this.bI(a,null)}}
A.by.prototype={
ai(a,b){var s=this.a
if((s.a&30)!==0)throw A.c(A.bS("Future already completed"))
s.ad(b)},
b5(a){return this.ai(a,null)}}
A.bX.prototype={
ew(a){if((this.c&15)!==6)return!0
return this.b.b.bW(this.d,a.a)},
er(a){var s,r=this.e,q=null,p=this.b.b
if(t.C.b(r))q=p.eE(r,a.a,a.b)
else q=p.bW(r,a.a)
try{p=q
return p}catch(s){if(t.eK.b(A.X(s))){if((this.c&1)!==0)throw A.c(A.an("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.c(A.an("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.I.prototype={
be(a,b,c){var s,r,q=$.F
if(q===B.i){if(b!=null&&!t.C.b(b)&&!t.v.b(b))throw A.c(A.eX(b,"onError",u.c))}else if(b!=null)b=A.xt(b,q)
s=new A.I(q,c.i("I<0>"))
r=b==null?1:3
this.aV(new A.bX(s,r,a,b,this.$ti.i("@<1>").G(c).i("bX<1,2>")))
return s},
df(a,b){return this.be(a,null,b)},
cB(a,b,c){var s=new A.I($.F,c.i("I<0>"))
this.aV(new A.bX(s,19,a,b,this.$ti.i("@<1>").G(c).i("bX<1,2>")))
return s},
bg(a){var s=this.$ti,r=new A.I($.F,s)
this.aV(new A.bX(r,8,a,null,s.i("@<1>").G(s.c).i("bX<1,2>")))
return r},
e7(a){this.a=this.a&1|16
this.c=a},
bq(a){this.a=a.a&30|this.a&1
this.c=a.c},
aV(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.aV(a)
return}s.bq(r)}A.dv(null,null,s.b,new A.mK(s,a))}},
ct(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.ct(a)
return}n.bq(s)}m.a=n.b1(a)
A.dv(null,null,n.b,new A.mS(m,n))}},
b0(){var s=this.c
this.c=null
return this.b1(s)},
b1(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
bo(a){var s,r,q,p=this
p.a^=2
try{a.be(new A.mO(p),new A.mP(p),t.P)}catch(q){s=A.X(q)
r=A.aY(q)
A.rb(new A.mQ(p,s,r))}},
bs(a){var s,r=this,q=r.$ti
if(q.i("aB<1>").b(a))if(q.b(a))A.mN(a,r)
else r.bo(a)
else{s=r.b0()
r.a=8
r.c=a
A.dk(r,s)}},
bt(a){var s=this,r=s.b0()
s.a=8
s.c=a
A.dk(s,r)},
am(a,b){var s=this.b0()
this.e7(A.hO(a,b))
A.dk(this,s)},
ad(a){if(this.$ti.i("aB<1>").b(a)){this.ca(a)
return}this.dI(a)},
dI(a){this.a^=2
A.dv(null,null,this.b,new A.mM(this,a))},
ca(a){var s=this
if(s.$ti.b(a)){if((a.a&16)!==0){s.a^=2
A.dv(null,null,s.b,new A.mR(s,a))}else A.mN(a,s)
return}s.bo(a)},
bm(a,b){this.a^=2
A.dv(null,null,this.b,new A.mL(this,a,b))},
$iaB:1}
A.mK.prototype={
$0(){A.dk(this.a,this.b)},
$S:1}
A.mS.prototype={
$0(){A.dk(this.b,this.a.a)},
$S:1}
A.mO.prototype={
$1(a){var s,r,q,p=this.a
p.a^=2
try{p.bt(a)}catch(q){s=A.X(q)
r=A.aY(q)
p.am(s,r)}},
$S:16}
A.mP.prototype={
$2(a,b){this.a.am(a,b)},
$S:46}
A.mQ.prototype={
$0(){this.a.am(this.b,this.c)},
$S:1}
A.mM.prototype={
$0(){this.a.bt(this.b)},
$S:1}
A.mR.prototype={
$0(){A.mN(this.b,this.a)},
$S:1}
A.mL.prototype={
$0(){this.a.am(this.b,this.c)},
$S:1}
A.mV.prototype={
$0(){var s,r,q,p,o,n,m=this,l=null
try{q=m.a.a
l=q.b.b.dc(q.d)}catch(p){s=A.X(p)
r=A.aY(p)
if(m.c){q=m.b.a.c.a
o=s
o=q==null?o==null:q===o
q=o}else q=!1
o=m.a
if(q)o.c=m.b.a.c
else o.c=A.hO(s,r)
o.b=!0
return}if(l instanceof A.I&&(l.a&24)!==0){if((l.a&16)!==0){q=m.a
q.c=l.c
q.b=!0}return}if(t.d.b(l)){n=m.b.a
q=m.a
q.c=l.df(new A.mW(n),t.z)
q.b=!1}},
$S:1}
A.mW.prototype={
$1(a){return this.a},
$S:52}
A.mU.prototype={
$0(){var s,r,q,p,o
try{q=this.a
p=q.a
q.c=p.b.b.bW(p.d,this.b)}catch(o){s=A.X(o)
r=A.aY(o)
q=this.a
q.c=A.hO(s,r)
q.b=!0}},
$S:1}
A.mT.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this
try{s=k.a.a.c
p=k.b
if(p.a.ew(s)&&p.a.e!=null){p.c=p.a.er(s)
p.b=!1}}catch(o){r=A.X(o)
q=A.aY(o)
p=k.a.a.c
n=p.a
m=r
l=k.b
if(n==null?m==null:n===m)l.c=p
else l.c=A.hO(r,q)
l.b=!0}},
$S:1}
A.h0.prototype={}
A.aV.prototype={
gh(a){var s={},r=new A.I($.F,t.fJ)
s.a=0
this.aN(new A.m6(s,this),!0,new A.m7(s,r),r.gci())
return r},
gb7(a){var s=new A.I($.F,A.D(this).i("I<1>")),r=this.aN(null,!0,new A.m4(s),s.gci())
r.d0(new A.m5(this,r,s))
return s}}
A.m6.prototype={
$1(a){++this.a.a},
$S(){return A.D(this.b).i("~(1)")}}
A.m7.prototype={
$0(){this.b.bs(this.a.a)},
$S:1}
A.m4.prototype={
$0(){var s,r,q,p,o,n
try{q=A.jp()
throw A.c(q)}catch(p){s=A.X(p)
r=A.aY(p)
o=s
n=r
if(n==null)n=A.hP(o)
this.a.am(o,n)}},
$S:1}
A.m5.prototype={
$1(a){A.x0(this.b,this.c,a)},
$S(){return A.D(this.a).i("~(1)")}}
A.fO.prototype={}
A.fP.prototype={}
A.hk.prototype={
ge1(){if((this.b&8)===0)return this.a
return this.a.gbZ()},
bw(){var s,r=this
if((r.b&8)===0){s=r.a
return s==null?r.a=new A.ev():s}s=r.a.gbZ()
return s},
gcw(){var s=this.a
return(this.b&8)!==0?s.gbZ():s},
bn(){if((this.b&4)!==0)return new A.bR("Cannot add event after closing")
return new A.bR("Cannot add event while adding a stream")},
ck(){var s=this.c
if(s==null)s=this.c=(this.b&2)!==0?$.hF():new A.I($.F,t.D)
return s},
w(a,b){if(this.b>=4)throw A.c(this.bn())
this.c8(b)},
ah(a){var s=this,r=s.b
if((r&4)!==0)return s.ck()
if(r>=4)throw A.c(s.bn())
s.cf()
return s.ck()},
cf(){var s=this.b|=4
if((s&1)!==0)this.bF()
else if((s&3)===0)this.bw().w(0,B.a9)},
c8(a){var s=this.b
if((s&1)!==0)this.b2(a)
else if((s&3)===0)this.bw().w(0,new A.dj(a))},
ec(a,b,c,d){var s,r,q,p,o,n,m=this
if((m.b&3)!==0)throw A.c(A.bS("Stream has already been listened to."))
s=$.F
r=d?1:0
q=A.qk(s,a)
A.wk(s,b)
p=new A.ei(m,q,c,s,r)
o=m.ge1()
s=m.b|=1
if((s&8)!==0){n=m.a
n.sbZ(p)
n.az()}else m.a=p
p.e8(o)
p.bB(new A.ne(m))
return p},
e3(a){var s,r,q,p,o,n,m,l=this,k=null
if((l.b&8)!==0)k=l.a.J()
l.a=null
l.b=l.b&4294967286|2
s=l.r
if(s!=null)if(k==null)try{r=s.$0()
if(t.bq.b(r))k=r}catch(o){q=A.X(o)
p=A.aY(o)
n=new A.I($.F,t.D)
n.bm(q,p)
k=n}else k=k.bg(s)
m=new A.nd(l)
if(k!=null)k=k.bg(m)
else m.$0()
return k}}
A.ne.prototype={
$0(){A.oP(this.a.d)},
$S:1}
A.nd.prototype={
$0(){var s=this.a.c
if(s!=null&&(s.a&30)===0)s.ad(null)},
$S:1}
A.h1.prototype={
b2(a){this.gcw().c6(new A.dj(a))},
bF(){this.gcw().c6(B.a9)}}
A.b8.prototype={}
A.b9.prototype={
gC(a){return(A.dc(this.a)^892482866)>>>0},
N(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.b9&&b.a===this.a}}
A.ei.prototype={
cn(){return this.x.e3(this)},
aZ(){var s=this.x
if((s.b&8)!==0)s.a.bd(0)
A.oP(s.e)},
b_(){var s=this.x
if((s.b&8)!==0)s.a.az()
A.oP(s.f)}}
A.ee.prototype={
e8(a){var s=this
if(a==null)return
s.r=a
if(a.c!=null){s.e=(s.e|64)>>>0
a.aS(s)}},
d0(a){this.a=A.qk(this.d,a)},
d5(a,b){var s,r,q=this,p=q.e
if((p&8)!==0)return
s=(p+128|4)>>>0
q.e=s
if(p<128){r=q.r
if(r!=null)if(r.a===1)r.a=3}if((p&4)===0&&(s&32)===0)q.bB(q.gcq())},
bd(a){return this.d5(a,null)},
az(){var s=this,r=s.e
if((r&8)!==0)return
if(r>=128){r=s.e=r-128
if(r<128)if((r&64)!==0&&s.r.c!=null)s.r.aS(s)
else{r=(r&4294967291)>>>0
s.e=r
if((r&32)===0)s.bB(s.gcr())}}},
J(){var s=this,r=(s.e&4294967279)>>>0
s.e=r
if((r&8)===0)s.c9()
r=s.f
return r==null?$.hF():r},
c9(){var s,r=this,q=r.e=(r.e|8)>>>0
if((q&64)!==0){s=r.r
if(s.a===1)s.a=3}if((q&32)===0)r.r=null
r.f=r.cn()},
aZ(){},
b_(){},
cn(){return null},
c6(a){var s,r=this,q=r.r
if(q==null)q=new A.ev()
r.r=q
q.w(0,a)
s=r.e
if((s&64)===0){s=(s|64)>>>0
r.e=s
if(s<128)q.aS(r)}},
b2(a){var s=this,r=s.e
s.e=(r|32)>>>0
s.d.de(s.a,a)
s.e=(s.e&4294967263)>>>0
s.ce((r&4)!==0)},
bF(){var s,r=this,q=new A.mF(r)
r.c9()
r.e=(r.e|16)>>>0
s=r.f
if(s!=null&&s!==$.hF())s.bg(q)
else q.$0()},
bB(a){var s=this,r=s.e
s.e=(r|32)>>>0
a.$0()
s.e=(s.e&4294967263)>>>0
s.ce((r&4)!==0)},
ce(a){var s,r,q=this,p=q.e
if((p&64)!==0&&q.r.c==null){p=q.e=(p&4294967231)>>>0
if((p&4)!==0)if(p<128){s=q.r
s=s==null?null:s.c==null
s=s!==!1}else s=!1
else s=!1
if(s){p=(p&4294967291)>>>0
q.e=p}}for(;!0;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=(p^32)>>>0
if(r)q.aZ()
else q.b_()
p=(q.e&4294967263)>>>0
q.e=p}if((p&64)!==0&&p<128)q.r.aS(q)}}
A.mF.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=(r|42)>>>0
s.d.dd(s.c)
s.e=(s.e&4294967263)>>>0},
$S:1}
A.eu.prototype={
aN(a,b,c,d){return this.a.ec(a,d,c,b===!0)},
b9(a,b,c){return this.aN(a,null,b,c)}}
A.h5.prototype={
gaw(){return this.a},
saw(a){return this.a=a}}
A.dj.prototype={
d6(a){a.b2(this.b)}}
A.mG.prototype={
d6(a){a.bF()},
gaw(){return null},
saw(a){throw A.c(A.bS("No events after a done."))}}
A.hh.prototype={
aS(a){var s=this,r=s.a
if(r===1)return
if(r>=1){s.a=1
return}A.rb(new A.n8(s,a))
s.a=1}}
A.n8.prototype={
$0(){var s,r,q=this.a,p=q.a
q.a=0
if(p===3)return
s=q.b
r=s.gaw()
q.b=r
if(r==null)q.c=null
s.d6(this.b)},
$S:1}
A.ev.prototype={
w(a,b){var s=this,r=s.c
if(r==null)s.b=s.c=b
else{r.saw(b)
s.c=b}}}
A.hl.prototype={}
A.nn.prototype={
$0(){return this.a.bs(this.b)},
$S:1}
A.nk.prototype={}
A.nF.prototype={
$0(){A.vb(this.a,this.b)
A.b5(u.g)},
$S:1}
A.na.prototype={
dd(a){var s,r,q
try{if(B.i===$.F){a.$0()
return}A.qK(null,null,this,a)}catch(q){s=A.X(q)
r=A.aY(q)
A.hB(s,r)}},
eH(a,b){var s,r,q
try{if(B.i===$.F){a.$1(b)
return}A.qL(null,null,this,a,b)}catch(q){s=A.X(q)
r=A.aY(q)
A.hB(s,r)}},
de(a,b){return this.eH(a,b,t.z)},
cF(a){return new A.nb(this,a)},
ef(a,b){return new A.nc(this,a,b)},
eD(a){if($.F===B.i)return a.$0()
return A.qK(null,null,this,a)},
dc(a){return this.eD(a,t.z)},
eG(a,b){if($.F===B.i)return a.$1(b)
return A.qL(null,null,this,a,b)},
bW(a,b){return this.eG(a,b,t.z,t.z)},
eF(a,b,c){if($.F===B.i)return a.$2(b,c)
return A.xu(null,null,this,a,b,c)},
eE(a,b,c){return this.eF(a,b,c,t.z,t.z,t.z)},
eB(a){return a},
bV(a){return this.eB(a,t.z,t.z,t.z)}}
A.nb.prototype={
$0(){return this.a.dd(this.b)},
$S:1}
A.nc.prototype={
$1(a){return this.a.de(this.b,a)},
$S(){return this.c.i("~(0)")}}
A.n6.prototype={
aJ(a){return A.o7(a)&1073741823},
aK(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;++r){q=a[r].a
if(q==null?b==null:q===b)return r}return-1}}
A.el.prototype={
j(a,b){if(!this.z.$1(b))return null
return this.dt(b)},
m(a,b,c){this.du(b,c)},
B(a){if(!this.z.$1(a))return!1
return this.ds(a)},
aJ(a){return this.y.$1(a)&1073741823},
aK(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=this.x,q=0;q<s;++q)if(r.$2(a[q].a,b))return q
return-1}}
A.n4.prototype={
$1(a){return this.a.b(a)},
$S:55}
A.ba.prototype={
gD(a){var s=this,r=new A.cV(s,s.r,A.D(s).i("cV<1>"))
r.c=s.e
return r},
gh(a){return this.a},
gv(a){return this.a===0},
gP(a){return this.a!==0},
I(a,b){var s,r
if(typeof b=="string"&&b!=="__proto__"){s=this.b
if(s==null)return!1
return s[b]!=null}else if(typeof b=="number"&&(b&1073741823)===b){r=this.c
if(r==null)return!1
return r[b]!=null}else return this.dM(b)},
dM(a){var s=this.d
if(s==null)return!1
return this.bz(s[this.bu(a)],a)>=0},
w(a,b){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.cg(s==null?q.b=A.oA():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.cg(r==null?q.c=A.oA():r,b)}else return q.dF(b)},
dF(a){var s,r,q=this,p=q.d
if(p==null)p=q.d=A.oA()
s=q.bu(a)
r=p[s]
if(r==null)p[s]=[q.br(a)]
else{if(q.bz(r,a)>=0)return!1
r.push(q.br(a))}return!0},
ax(a,b){var s=this
if(typeof b=="string"&&b!=="__proto__")return s.cu(s.b,b)
else if(typeof b=="number"&&(b&1073741823)===b)return s.cu(s.c,b)
else return s.e4(b)},
e4(a){var s,r,q,p,o=this,n=o.d
if(n==null)return!1
s=o.bu(a)
r=n[s]
q=o.bz(r,a)
if(q<0)return!1
p=r.splice(q,1)[0]
if(0===r.length)delete n[s]
o.cD(p)
return!0},
dP(a,b){var s,r,q,p,o=this,n=o.e
for(;n!=null;n=r){s=n.a
r=n.b
q=o.r
p=a.$1(s)
if(q!==o.r)throw A.c(A.aa(o))
if(!1===p)o.ax(0,s)}},
at(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.bC()}},
cg(a,b){if(a[b]!=null)return!1
a[b]=this.br(b)
return!0},
cu(a,b){var s
if(a==null)return!1
s=a[b]
if(s==null)return!1
this.cD(s)
delete a[b]
return!0},
bC(){this.r=this.r+1&1073741823},
br(a){var s,r=this,q=new A.n5(a)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.c=s
r.f=s.b=q}++r.a
r.bC()
return q},
cD(a){var s=this,r=a.c,q=a.b
if(r==null)s.e=q
else r.b=q
if(q==null)s.f=r
else q.c=r;--s.a
s.bC()},
bu(a){return J.d0(a)&1073741823},
bz(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.am(a[r].a,b))return r
return-1}}
A.n5.prototype={}
A.cV.prototype={
gt(){return this.d},
p(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.c(A.aa(q))
else if(r==null){s.d=null
return!1}else{s.d=r.a
s.c=r.b
return!0}},
$iR:1}
A.b7.prototype={
af(a,b){return new A.b7(J.pu(this.a,b),b.i("b7<0>"))},
gh(a){return J.a9(this.a)},
j(a,b){return J.eT(this.a,b)}}
A.dN.prototype={}
A.dW.prototype={$in:1,$iq:1}
A.o.prototype={
gD(a){return new A.aq(a,this.gh(a),A.al(a).i("aq<o.E>"))},
L(a,b){return this.j(a,b)},
gv(a){return this.gh(a)===0},
gP(a){return!this.gv(a)},
gb7(a){if(this.gh(a)===0)throw A.c(A.jp())
return this.j(a,0)},
I(a,b){var s,r=this.gh(a)
for(s=0;s<r;++s){if(J.am(this.j(a,s),b))return!0
if(r!==this.gh(a))throw A.c(A.aa(a))}return!1},
b6(a,b){var s,r=this.gh(a)
for(s=0;s<r;++s){if(!b.$1(this.j(a,s)))return!1
if(r!==this.gh(a))throw A.c(A.aa(a))}return!0},
aF(a,b){var s,r=this.gh(a)
for(s=0;s<r;++s){if(b.$1(this.j(a,s)))return!0
if(r!==this.gh(a))throw A.c(A.aa(a))}return!1},
av(a,b,c){var s,r,q=this.gh(a)
for(s=0;s<q;++s){r=this.j(a,s)
if(b.$1(r))return r
if(q!==this.gh(a))throw A.c(A.aa(a))}return c.$0()},
ak(a,b,c){return new A.a8(a,b,A.al(a).i("@<o.E>").G(c).i("a8<1,2>"))},
a1(a,b){return A.ea(a,b,null,A.al(a).i("o.E"))},
aP(a,b){var s,r,q,p,o=this
if(o.gv(a)){s=J.bm(0,A.al(a).i("o.E"))
return s}r=o.j(a,0)
q=A.W(o.gh(a),r,!1,A.al(a).i("o.E"))
for(p=1;p<o.gh(a);++p)q[p]=o.j(a,p)
return q},
bX(a){var s,r=A.ks(A.al(a).i("o.E"))
for(s=0;s<this.gh(a);++s)r.w(0,this.j(a,s))
return r},
w(a,b){var s=this.gh(a)
this.sh(a,s+1)
this.m(a,s,b)},
af(a,b){return new A.bg(a,A.al(a).i("@<o.E>").G(b).i("bg<1,2>"))},
a2(a,b,c){var s=this.gh(a)
A.aS(b,c,s)
return A.ov(this.aR(a,b,c),A.al(a).i("o.E"))},
aR(a,b,c){A.aS(b,c,this.gh(a))
return A.ea(a,b,c,A.al(a).i("o.E"))},
eo(a,b,c,d){var s
A.aS(b,c,this.gh(a))
for(s=b;s<c;++s)this.m(a,s,d)},
a5(a,b,c,d,e){var s,r,q,p,o
A.aS(b,c,this.gh(a))
s=c-b
if(s===0)return
A.b4(e,"skipCount")
if(A.al(a).i("q<o.E>").b(d)){r=e
q=d}else{q=J.pv(d,e).aP(0,!1)
r=0}p=J.S(q)
if(r+s>p.gh(q))throw A.c(A.vj())
if(r<b)for(o=s-1;o>=0;--o)this.m(a,b+o,p.j(q,r+o))
else for(o=0;o<s;++o)this.m(a,b+o,p.j(q,r+o))},
bN(a,b){var s
for(s=0;s<this.gh(a);++s)if(J.am(this.j(a,s),b))return s
return-1},
k(a){return A.jo(a,"[","]")}}
A.dX.prototype={}
A.ku.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=r.a+=A.b(a)
r.a=s+": "
r.a+=A.b(b)},
$S:8}
A.N.prototype={
ag(a,b,c){var s=A.D(this)
return A.pR(this,s.i("N.K"),s.i("N.V"),b,c)},
K(a,b){var s,r
for(s=J.ah(this.gM());s.p();){r=s.gt()
b.$2(r,this.j(0,r))}},
gem(a){return J.bc(this.gM(),new A.kv(this),A.D(this).i("d9<N.K,N.V>"))},
B(a){return J.ok(this.gM(),a)},
gh(a){return J.a9(this.gM())},
gv(a){return J.om(this.gM())},
k(a){return A.ow(this)},
$ih:1}
A.kv.prototype={
$1(a){var s=this.a,r=A.D(s)
return new A.d9(a,s.j(0,a),r.i("@<N.K>").G(r.i("N.V")).i("d9<1,2>"))},
$S(){return A.D(this.a).i("d9<N.K,N.V>(N.K)")}}
A.hp.prototype={
m(a,b,c){throw A.c(A.a1("Cannot modify unmodifiable map"))}}
A.dY.prototype={
ag(a,b,c){return this.a.ag(0,b,c)},
j(a,b){return this.a.j(0,b)},
m(a,b,c){this.a.m(0,b,c)},
B(a){return this.a.B(a)},
K(a,b){this.a.K(0,b)},
gv(a){var s=this.a
return s.gv(s)},
gh(a){var s=this.a
return s.gh(s)},
gM(){return this.a.gM()},
k(a){return this.a.k(0)},
$ih:1}
A.bw.prototype={
ag(a,b,c){return new A.bw(this.a.ag(0,b,c),b.i("@<0>").G(c).i("bw<1,2>"))}}
A.a4.prototype={
gv(a){return this.gh(this)===0},
gP(a){return this.gh(this)!==0},
H(a,b){var s
for(s=J.ah(b);s.p();)this.w(0,s.gt())},
ak(a,b,c){return new A.bi(this,b,A.D(this).i("@<a4.E>").G(c).i("bi<1,2>"))},
k(a){return A.jo(this,"{","}")},
b6(a,b){var s
for(s=this.gD(this);s.p();)if(!b.$1(s.gt()))return!1
return!0},
aj(a,b){var s,r=this.gD(this)
if(!r.p())return""
if(b===""){s=""
do s+=A.b(r.gt())
while(r.p())}else{s=A.b(r.gt())
for(;r.p();)s=s+b+A.b(r.gt())}return s.charCodeAt(0)==0?s:s},
a1(a,b){return A.oy(this,b,A.D(this).i("a4.E"))},
av(a,b,c){var s,r
for(s=this.gD(this);s.p();){r=s.gt()
if(b.$1(r))return r}return c.$0()},
L(a,b){var s,r,q,p="index"
A.cX(b,p,t.S)
A.b4(b,p)
for(s=this.gD(this),r=0;s.p();){q=s.gt()
if(b===r)return q;++r}throw A.c(A.d6(b,this,p,null,r))}}
A.e6.prototype={$in:1,$iak:1}
A.dn.prototype={$in:1,$iak:1}
A.hq.prototype={
w(a,b){A.wG()
return A.b5(u.g)}}
A.eD.prototype={
I(a,b){return this.a.B(b)},
gD(a){return J.ah(this.a.gM())},
gh(a){var s=this.a
return s.gh(s)}}
A.em.prototype={}
A.es.prototype={}
A.eC.prototype={}
A.eH.prototype={}
A.eI.prototype={}
A.he.prototype={
j(a,b){var s,r=this.b
if(r==null)return this.c.j(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.e2(b):s}},
gh(a){var s
if(this.b==null){s=this.c
s=s.gh(s)}else s=this.aC().length
return s},
gv(a){return this.gh(this)===0},
gM(){if(this.b==null)return this.c.gM()
return new A.hf(this)},
m(a,b,c){var s,r,q=this
if(q.b==null)q.c.m(0,b,c)
else if(q.B(b)){s=q.b
s[b]=c
r=q.a
if(r==null?s!=null:r!==s)r[b]=null}else q.ed().m(0,b,c)},
B(a){if(this.b==null)return this.c.B(a)
if(typeof a!="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
K(a,b){var s,r,q,p,o=this
if(o.b==null)return o.c.K(0,b)
s=o.aC()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.no(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.c(A.aa(o))}},
aC(){var s=this.c
if(s==null)s=this.c=A.a(Object.keys(this.a),t.s)
return s},
ed(){var s,r,q,p,o,n=this
if(n.b==null)return n.c
s=A.ai(t.R,t.z)
r=n.aC()
for(q=0;p=r.length,q<p;++q){o=r[q]
s.m(0,o,n.j(0,o))}if(p===0)r.push("")
else B.d.sh(r,0)
n.a=n.b=null
return n.c=s},
e2(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.no(this.a[a])
return this.b[a]=s}}
A.hf.prototype={
gh(a){var s=this.a
return s.gh(s)},
L(a,b){var s=this.a
return s.b==null?s.gM().L(0,b):s.aC()[b]},
gD(a){var s=this.a
if(s.b==null){s=s.gM()
s=s.gD(s)}else{s=s.aC()
s=new J.bf(s,s.length,A.a2(s).i("bf<1>"))}return s},
I(a,b){return this.a.B(b)}}
A.mZ.prototype={
ah(a){var s,r,q,p=this
p.dD(0)
s=p.a
r=s.a
s.a=""
s=p.c
q=s.b
q.push(A.xq(r.charCodeAt(0)==0?r:r,p.b))
s.a.$1(q)}}
A.mk.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:18}
A.mj.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:18}
A.hQ.prototype={
ey(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c="Invalid base64 encoding length "
a0=A.aS(b,a0,a.length)
s=$.pk()
for(r=b,q=r,p=null,o=-1,n=-1,m=0;r<a0;r=l){l=r+1
k=B.a.E(a,r)
if(k===37){j=l+2
if(j<=a0){i=A.r7(a,l)
if(i===37)i=-1
l=j}else i=-1}else i=k
if(0<=i&&i<=127){h=s[i]
if(h>=0){i=B.a.A("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",h)
if(i===k)continue
k=i}else{if(h===-1){if(o<0){g=p==null?null:p.a.length
if(g==null)g=0
o=g+(r-q)
n=r}++m
if(k===61)continue}k=i}if(h!==-2){if(p==null){p=new A.ab("")
g=p}else g=p
f=g.a+=B.a.u(a,q,r)
g.a=f+A.P(k)
q=l
continue}}throw A.c(A.V("Invalid base64 data",a,r))}if(p!=null){g=p.a+=B.a.u(a,q,a0)
f=g.length
if(o>=0)A.pz(a,n,a0,o,m,f)
else{e=B.c.bi(f-1,4)+1
if(e===1)throw A.c(A.V(c,a,a0))
for(;e<4;){g+="="
p.a=g;++e}}g=p.a
return B.a.ay(a,b,a0,g.charCodeAt(0)==0?g:g)}d=a0-b
if(o>=0)A.pz(a,n,a0,o,m,d)
else{e=B.c.bi(d,4)
if(e===1)throw A.c(A.V(c,a,a0))
if(e>1)a=B.a.ay(a,a0,a0,e===2?"==":"=")}return a}}
A.hS.prototype={}
A.hR.prototype={
ei(a,b){var s,r,q,p=A.aS(b,null,a.length)
if(b===p)return new Uint8Array(0)
s=new A.mE()
r=s.ej(0,a,b,p)
r.toString
q=s.a
if(q<-1)A.a3(A.V("Missing padding character",a,p))
if(q>0)A.a3(A.V("Invalid length, must be multiple of four",a,p))
s.a=-1
return r}}
A.mE.prototype={
ej(a,b,c,d){var s,r=this,q=r.a
if(q<0){r.a=A.qj(b,c,d,q)
return null}if(c===d)return new Uint8Array(0)
s=A.wh(b,c,d,q)
r.a=A.wj(b,c,d,s,0,r.a)
return s}}
A.hT.prototype={}
A.f0.prototype={}
A.hi.prototype={}
A.f4.prototype={}
A.f6.prototype={}
A.iJ.prototype={}
A.dS.prototype={
k(a){var s=A.cl(this.a)
return(this.b!=null?"Converting object to an encodable object failed:":"Converting object did not return an encodable object:")+" "+s}}
A.fm.prototype={
k(a){return"Cyclic error in JSON stringify"}}
A.jx.prototype={
gel(){return B.bY}}
A.jy.prototype={}
A.n2.prototype={
c0(a){var s,r,q,p,o,n,m=a.length
for(s=this.c,r=0,q=0;q<m;++q){p=B.a.E(a,q)
if(p>92){if(p>=55296){o=p&64512
if(o===55296){n=q+1
n=!(n<m&&(B.a.E(a,n)&64512)===56320)}else n=!1
if(!n)if(o===56320){o=q-1
o=!(o>=0&&(B.a.A(a,o)&64512)===55296)}else o=!1
else o=!0
if(o){if(q>r)s.a+=B.a.u(a,r,q)
r=q+1
o=s.a+=A.P(92)
o+=A.P(117)
s.a=o
o+=A.P(100)
s.a=o
n=p>>>8&15
o+=A.P(n<10?48+n:87+n)
s.a=o
n=p>>>4&15
o+=A.P(n<10?48+n:87+n)
s.a=o
n=p&15
s.a=o+A.P(n<10?48+n:87+n)}}continue}if(p<32){if(q>r)s.a+=B.a.u(a,r,q)
r=q+1
o=s.a+=A.P(92)
switch(p){case 8:s.a=o+A.P(98)
break
case 9:s.a=o+A.P(116)
break
case 10:s.a=o+A.P(110)
break
case 12:s.a=o+A.P(102)
break
case 13:s.a=o+A.P(114)
break
default:o+=A.P(117)
s.a=o
o+=A.P(48)
s.a=o
o+=A.P(48)
s.a=o
n=p>>>4&15
o+=A.P(n<10?48+n:87+n)
s.a=o
n=p&15
s.a=o+A.P(n<10?48+n:87+n)
break}}else if(p===34||p===92){if(q>r)s.a+=B.a.u(a,r,q)
r=q+1
o=s.a+=A.P(92)
s.a=o+A.P(p)}}if(r===0)s.a+=a
else if(r<m)s.a+=B.a.u(a,r,m)},
bp(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<r;++q){p=s[q]
if(a==null?p==null:a===p)throw A.c(new A.fm(a,null))}s.push(a)},
ar(a){var s,r,q,p,o=this
if(o.di(a))return
o.bp(a)
try{s=o.b.$1(a)
if(!o.di(s)){q=A.pN(a,null,o.gcs())
throw A.c(q)}o.a.pop()}catch(p){r=A.X(p)
q=A.pN(a,r,o.gcs())
throw A.c(q)}},
di(a){var s,r,q=this
if(typeof a=="number"){if(!isFinite(a))return!1
q.c.a+=B.C.k(a)
return!0}else if(a===!0){q.c.a+="true"
return!0}else if(a===!1){q.c.a+="false"
return!0}else if(a==null){q.c.a+="null"
return!0}else if(typeof a=="string"){s=q.c
s.a+='"'
q.c0(a)
s.a+='"'
return!0}else if(t.aH.b(a)){q.bp(a)
q.dj(a)
q.a.pop()
return!0}else if(t.eO.b(a)){q.bp(a)
r=q.dk(a)
q.a.pop()
return r}else return!1},
dj(a){var s,r,q=this.c
q.a+="["
s=J.S(a)
if(s.gP(a)){this.ar(s.j(a,0))
for(r=1;r<s.gh(a);++r){q.a+=","
this.ar(s.j(a,r))}}q.a+="]"},
dk(a){var s,r,q,p,o,n=this,m={}
if(a.gv(a)){n.c.a+="{}"
return!0}s=a.gh(a)*2
r=A.W(s,null,!1,t.O)
q=m.a=0
m.b=!0
a.K(0,new A.n3(m,r))
if(!m.b)return!1
p=n.c
p.a+="{"
for(o='"';q<s;q+=2,o=',"'){p.a+=o
n.c0(r[q])
p.a+='":'
n.ar(r[q+1])}p.a+="}"
return!0}}
A.n3.prototype={
$2(a,b){var s,r,q,p
if(typeof a!="string")this.a.b=!1
s=this.b
r=this.a
q=r.a
p=r.a=q+1
s[q]=a
r.a=p+1
s[p]=b},
$S:8}
A.n_.prototype={
dj(a){var s,r=this,q=J.S(a),p=q.gv(a),o=r.c,n=o.a
if(p)o.a=n+"[]"
else{o.a=n+"[\n"
r.aQ(++r.b$)
r.ar(q.j(a,0))
for(s=1;s<q.gh(a);++s){o.a+=",\n"
r.aQ(r.b$)
r.ar(q.j(a,s))}o.a+="\n"
r.aQ(--r.b$)
o.a+="]"}},
dk(a){var s,r,q,p,o,n=this,m={}
if(a.gv(a)){n.c.a+="{}"
return!0}s=a.gh(a)*2
r=A.W(s,null,!1,t.O)
q=m.a=0
m.b=!0
a.K(0,new A.n0(m,r))
if(!m.b)return!1
p=n.c
p.a+="{\n";++n.b$
for(o="";q<s;q+=2,o=",\n"){p.a+=o
n.aQ(n.b$)
p.a+='"'
n.c0(r[q])
p.a+='": '
n.ar(r[q+1])}p.a+="\n"
n.aQ(--n.b$)
p.a+="}"
return!0}}
A.n0.prototype={
$2(a,b){var s,r,q,p
if(typeof a!="string")this.a.b=!1
s=this.b
r=this.a
q=r.a
p=r.a=q+1
s[q]=a
r.a=p+1
s[p]=b},
$S:8}
A.hg.prototype={
gcs(){var s=this.c.a
return s.charCodeAt(0)==0?s:s}}
A.n1.prototype={
aQ(a){var s,r,q
for(s=this.f,r=this.c,q=0;q<a;++q)r.a+=s}}
A.m8.prototype={}
A.m9.prototype={}
A.ew.prototype={
ah(a){}}
A.ni.prototype={
ah(a){this.a.eq(this.c)
this.b.ah(0)},
ee(a,b,c,d){this.c.a+=this.a.cJ(a,b,c,!1)}}
A.mh.prototype={}
A.mi.prototype={
eh(a){var s=this.a,r=A.wb(s,a,0,null)
if(r!=null)return r
return new A.hr(s).cJ(a,0,null,!0)}}
A.hr.prototype={
cJ(a,b,c,d){var s,r,q,p,o,n=this,m=A.aS(b,c,J.a9(a))
if(b===m)return""
if(t.gc.b(a)){s=a
r=0}else{s=A.wW(a,b,m)
m-=b
r=b
b=0}q=n.bv(s,b,m,d)
p=n.b
if((p&1)!==0){o=A.qz(p)
n.b=0
throw A.c(A.V(o,a,r+n.c))}return q},
bv(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.c.b3(b+c,2)
r=q.bv(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.bv(a,s,c,d)}return q.ek(a,b,c,d)},
eq(a){var s=this.b
this.b=0
if(s<=32)return
if(this.a)a.a+=A.P(65533)
else throw A.c(A.V(A.qz(77),null,null))},
ek(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.ab(""),g=b+1,f=a[b]
$label0$0:for(s=l.a;!0;){for(;!0;g=p){r=B.a.E("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=B.a.E(" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",j+r)
if(j===0){h.a+=A.P(i)
if(g===c)break $label0$0
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:h.a+=A.P(k)
break
case 65:h.a+=A.P(k);--g
break
default:q=h.a+=A.P(k)
h.a=q+A.P(k)
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break $label0$0
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){while(!0){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m)h.a+=A.P(a[m])
else h.a+=A.q9(a,g,o)
if(o===c)break $label0$0
g=p}else g=p}if(d&&j>32)if(s)h.a+=A.P(k)
else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.hs.prototype={}
A.kK.prototype={
$2(a,b){var s,r=this.b,q=this.a
r.a+=q.a
s=r.a+=A.b(a.a)
r.a=s+": "
r.a+=A.cl(b)
q.a=", "},
$S:59}
A.ck.prototype={
N(a,b){if(b==null)return!1
return b instanceof A.ck&&this.a===b.a&&this.b===b.b},
gC(a){var s=this.a
return(s^B.c.ae(s,30))&1073741823},
eK(){if(this.b)return this
return A.v7(this.a,!0)},
k(a){var s=this,r=A.pG(A.fG(s)),q=A.bh(A.q3(s)),p=A.bh(A.q_(s)),o=A.bh(A.q0(s)),n=A.bh(A.q2(s)),m=A.bh(A.q4(s)),l=A.pH(A.q1(s))
if(s.b)return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+"Z"
else return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l},
eJ(){var s=this,r=A.fG(s)>=-9999&&A.fG(s)<=9999?A.pG(A.fG(s)):A.v8(A.fG(s)),q=A.bh(A.q3(s)),p=A.bh(A.q_(s)),o=A.bh(A.q0(s)),n=A.bh(A.q2(s)),m=A.bh(A.q4(s)),l=A.pH(A.q1(s))
if(s.b)return r+"-"+q+"-"+p+"T"+o+":"+n+":"+m+"."+l+"Z"
else return r+"-"+q+"-"+p+"T"+o+":"+n+":"+m+"."+l}}
A.mH.prototype={}
A.G.prototype={
gaT(){return A.aY(this.$thrownJsError)}}
A.eY.prototype={
k(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.cl(s)
return"Assertion failed"}}
A.b6.prototype={}
A.fC.prototype={
k(a){return"Throw of null."}}
A.aN.prototype={
gby(){return"Invalid argument"+(!this.a?"(s)":"")},
gbx(){return""},
k(a){var s,r,q=this,p=q.c,o=p==null?"":" ("+p+")",n=q.d,m=n==null?"":": "+A.b(n),l=q.gby()+o+m
if(!q.a)return l
s=q.gbx()
r=A.cl(q.b)
return l+s+": "+r}}
A.e5.prototype={
gby(){return"RangeError"},
gbx(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.b(q):""
else if(q==null)s=": Not greater than or equal to "+A.b(r)
else if(q>r)s=": Not in inclusive range "+A.b(r)+".."+A.b(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.b(r)
return s}}
A.fh.prototype={
gby(){return"RangeError"},
gbx(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+A.b(s)},
gh(a){return this.f}}
A.fB.prototype={
k(a){var s,r,q,p,o,n,m,l,k=this,j={},i=new A.ab("")
j.a=""
s=k.c
for(r=s.length,q=0,p="",o="";q<r;++q,o=", "){n=s[q]
i.a=p+o
p=i.a+=A.cl(n)
j.a=", "}k.d.K(0,new A.kK(j,i))
m=A.cl(k.a)
l=i.k(0)
r="NoSuchMethodError: method not found: '"+A.b(k.b.a)+"'\nReceiver: "+m+"\nArguments: ["+l+"]"
return r}}
A.fW.prototype={
k(a){return"Unsupported operation: "+this.a}}
A.fR.prototype={
k(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.bR.prototype={
k(a){return"Bad state: "+this.a}}
A.f5.prototype={
k(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.cl(s)+"."}}
A.fE.prototype={
k(a){return"Out of Memory"},
gaT(){return null},
$iG:1}
A.e8.prototype={
k(a){return"Stack Overflow"},
gaT(){return null},
$iG:1}
A.f8.prototype={
k(a){var s=this.a
return s==null?"Reading static variable during its initialization":"Reading static variable '"+s+"' during its initialization"}}
A.h9.prototype={
k(a){return"Exception: "+this.a},
$iao:1}
A.bk.prototype={
k(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this.a,f=g!=null&&""!==g?"FormatException: "+A.b(g):"FormatException",e=this.c,d=this.b
if(typeof d=="string"){if(e!=null)s=e<0||e>d.length
else s=!1
if(s)e=null
if(e==null){if(d.length>78)d=B.a.u(d,0,75)+"..."
return f+"\n"+d}for(r=1,q=0,p=!1,o=0;o<e;++o){n=B.a.E(d,o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}f=r>1?f+(" (at line "+r+", character "+(e-q+1)+")\n"):f+(" (at character "+(e+1)+")\n")
m=d.length
for(o=e;o<m;++o){n=B.a.A(d,o)
if(n===10||n===13){m=o
break}}if(m-q>78)if(e-q<75){l=q+75
k=q
j=""
i="..."}else{if(m-e<75){k=m-75
l=m
i=""}else{k=e-36
l=e+36
i="..."}j="..."}else{l=m
k=q
j=""
i=""}h=B.a.u(d,k,l)
return f+j+h+i+"\n"+B.a.bj(" ",e-k+j.length)+"^\n"}else return e!=null?f+(" (at offset "+A.b(e)+")"):f},
$iao:1}
A.t.prototype={
af(a,b){return A.hU(this,A.D(this).i("t.E"),b)},
ak(a,b,c){return A.kw(this,b,A.D(this).i("t.E"),c)},
I(a,b){var s
for(s=this.gD(this);s.p();)if(J.am(s.gt(),b))return!0
return!1},
aF(a,b){var s
for(s=this.gD(this);s.p();)if(b.$1(s.gt()))return!0
return!1},
aP(a,b){return A.d8(this,!1,A.D(this).i("t.E"))},
gh(a){var s,r=this.gD(this)
for(s=0;r.p();)++s
return s},
gv(a){return!this.gD(this).p()},
gP(a){return!this.gv(this)},
a1(a,b){return A.oy(this,b,A.D(this).i("t.E"))},
L(a,b){var s,r,q
A.b4(b,"index")
for(s=this.gD(this),r=0;s.p();){q=s.gt()
if(b===r)return q;++r}throw A.c(A.d6(b,this,"index",null,r))},
k(a){return A.vi(this,"(",")")}}
A.ek.prototype={
L(a,b){var s=this.a
if(0>b||b>=s)A.a3(A.d6(b,this,"index",null,s))
return this.b.$1(b)},
gh(a){return this.a}}
A.R.prototype={}
A.d9.prototype={
k(a){return"MapEntry("+A.b(this.a)+": "+A.b(this.b)+")"}}
A.m.prototype={
gC(a){return A.e.prototype.gC.call(this,this)},
k(a){return"null"}}
A.e.prototype={$ie:1,
N(a,b){return this===b},
gC(a){return A.dc(this)},
k(a){return"Instance of '"+A.b(A.kT(this))+"'"},
bc(a,b){throw A.c(A.pX(this,b.gcX(),b.gd7(),b.gcZ()))},
toString(){return this.k(this)}}
A.hm.prototype={
k(a){return""},
$iaU:1}
A.m3.prototype={
gcL(){var s,r=this.b
if(r==null)r=$.e3.$0()
s=r-this.a
if($.pi()===1000)return s
return B.c.b3(s,1000)},
c3(a){var s=this,r=s.b
if(r!=null){s.a=s.a+($.e3.$0()-r)
s.b=null}},
d9(a){var s=this.b
this.a=s==null?$.e3.$0():s}}
A.ab.prototype={
gh(a){return this.a.length},
k(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.me.prototype={
$2(a,b){throw A.c(A.V("Illegal IPv4 address, "+a,this.a,b))},
$S:64}
A.mf.prototype={
$2(a,b){throw A.c(A.V("Illegal IPv6 address, "+a,this.a,b))},
$S:67}
A.mg.prototype={
$2(a,b){var s
if(b-a>4)this.a.$2("an IPv6 part can only contain a maximum of 4 hex digits",a)
s=A.cY(B.a.u(this.b,a,b),16)
if(s<0||s>65535)this.a.$2("each part must be in the range of `0x0..0xFFFF`",a)
return s},
$S:73}
A.eE.prototype={
gcA(){var s,r,q,p,o=this,n=o.x
if(n===$){s=o.a
r=s.length!==0?s+":":""
q=o.c
p=q==null
if(!p||s==="file"){s=r+"//"
r=o.b
if(r.length!==0)s=s+r+"@"
if(!p)s+=q
r=o.d
if(r!=null)s=s+":"+A.b(r)}else s=r
s+=o.e
r=o.f
if(r!=null)s=s+"?"+r
r=o.r
if(r!=null)s=s+"#"+r
A.qJ(o.x,"_text")
n=o.x=s.charCodeAt(0)==0?s:s}return n},
gC(a){var s,r=this,q=r.z
if(q===$){s=B.a.gC(r.gcA())
A.qJ(r.z,"hashCode")
r.z=s
q=s}return q},
gdh(){return this.b},
gbM(a){var s=this.c
if(s==null)return""
if(B.a.V(s,"["))return B.a.u(s,1,s.length-1)
return s},
gbS(a){var s=this.d
return s==null?A.qs(this.a):s},
gd8(){var s=this.f
return s==null?"":s},
gcN(){var s=this.r
return s==null?"":s},
gcP(){return this.a.length!==0},
gbJ(){return this.c!=null},
gbL(){return this.f!=null},
gbK(){return this.r!=null},
gcO(){return B.a.V(this.e,"/")},
k(a){return this.gcA()},
N(a,b){var s,r,q=this
if(b==null)return!1
if(q===b)return!0
if(t.l.b(b))if(q.a===b.gc2())if(q.c!=null===b.gbJ())if(q.b===b.gdh())if(q.gbM(q)===b.gbM(b))if(q.gbS(q)===b.gbS(b))if(q.e===b.gbR(b)){s=q.f
r=s==null
if(!r===b.gbL()){if(r)s=""
if(s===b.gd8()){s=q.r
r=s==null
if(!r===b.gbK()){if(r)s=""
s=s===b.gcN()}else s=!1}else s=!1}else s=!1}else s=!1
else s=!1
else s=!1
else s=!1
else s=!1
else s=!1
else s=!1
return s},
$ibV:1,
gc2(){return this.a},
gbR(a){return this.e}}
A.mc.prototype={
gdg(){var s,r,q,p,o=this,n=null,m=o.c
if(m==null){m=o.a
s=o.b[0]+1
r=B.a.b8(m,"?",s)
q=m.length
if(r>=0){p=A.eF(m,r+1,q,B.E,!1)
q=r}else p=n
m=o.c=new A.h4("data","",n,n,A.eF(m,s,q,B.aw,!1),p,n)}return m},
gbO(){var s=this.b,r=s[0]+1,q=s[1]
if(r===q)return"text/plain"
return A.qy(this.a,r,q,B.N,!1)},
cI(){var s,r,q,p,o,n,m,l,k=this.a,j=this.b,i=B.d.gaL(j)+1
if((j.length&1)===1)return B.b7.ei(k,i)
j=k.length
s=j-i
for(r=i;r<j;++r)if(B.a.A(k,r)===37){r+=2
s-=2}q=new Uint8Array(s)
if(s===j){B.j.a5(q,0,s,new A.d2(k),i)
return q}for(r=i,p=0;r<j;++r){o=B.a.A(k,r)
if(o!==37){n=p+1
q[p]=o}else{m=r+2
if(m<j){l=A.r7(k,r+1)
if(l>=0){n=p+1
q[p]=l
r=m
p=n
continue}}throw A.c(A.V("Invalid percent escape",k,r))}p=n}return q},
k(a){var s=this.a
return this.b[0]===-1?"data:"+s:s}}
A.nr.prototype={
$2(a,b){var s=this.a[a]
B.j.eo(s,0,96,b)
return s},
$S:79}
A.ns.prototype={
$3(a,b,c){var s,r
for(s=b.length,r=0;r<s;++r)a[B.a.E(b,r)^96]=c},
$S:19}
A.nt.prototype={
$3(a,b,c){var s,r
for(s=B.a.E(b,0),r=B.a.E(b,1);s<=r;++s)a[(s^96)>>>0]=c},
$S:19}
A.hj.prototype={
gcP(){return this.b>0},
gbJ(){return this.c>0},
gbL(){return this.f<this.r},
gbK(){return this.r<this.a.length},
gcO(){return B.a.W(this.a,"/",this.e)},
gc2(){var s=this.x
return s==null?this.x=this.dL():s},
dL(){var s,r=this,q=r.b
if(q<=0)return""
s=q===4
if(s&&B.a.V(r.a,"http"))return"http"
if(q===5&&B.a.V(r.a,"https"))return"https"
if(s&&B.a.V(r.a,"file"))return"file"
if(q===7&&B.a.V(r.a,"package"))return"package"
return B.a.u(r.a,0,q)},
gdh(){var s=this.c,r=this.b+3
return s>r?B.a.u(this.a,r,s-1):""},
gbM(a){var s=this.c
return s>0?B.a.u(this.a,s,this.d):""},
gbS(a){var s,r=this
if(r.c>0&&r.d+1<r.e)return A.cY(B.a.u(r.a,r.d+1,r.e),null)
s=r.b
if(s===4&&B.a.V(r.a,"http"))return 80
if(s===5&&B.a.V(r.a,"https"))return 443
return 0},
gbR(a){return B.a.u(this.a,this.e,this.f)},
gd8(){var s=this.f,r=this.r
return s<r?B.a.u(this.a,s+1,r):""},
gcN(){var s=this.r,r=this.a
return s<r.length?B.a.aU(r,s+1):""},
gC(a){var s=this.y
return s==null?this.y=B.a.gC(this.a):s},
N(a,b){if(b==null)return!1
if(this===b)return!0
return t.l.b(b)&&this.a===b.k(0)},
k(a){return this.a},
$ibV:1}
A.h4.prototype={}
A.k.prototype={}
A.eU.prototype={
k(a){return String(a)}}
A.eW.prototype={
k(a){return String(a)}}
A.cd.prototype={$icd:1}
A.b0.prototype={
gh(a){return a.length}}
A.dC.prototype={
gh(a){return a.length}}
A.i6.prototype={}
A.iH.prototype={
k(a){return String(a)}}
A.iI.prototype={
gh(a){return a.length}}
A.dD.prototype={
gaH(a){return new A.h6(a)},
k(a){return a.localName},
gd_(a){return new A.ax(a,"click",!1,t.G)},
gd1(a){return new A.ax(a,"dragenter",!1,t.G)},
gd2(a){return new A.ax(a,"dragleave",!1,t.G)},
gd3(a){return new A.ax(a,"dragover",!1,t.G)},
gd4(a){return new A.ax(a,"drop",!1,t.G)}}
A.j.prototype={$ij:1}
A.f9.prototype={
dH(a,b,c,d){return a.addEventListener(b,A.eM(c,1),!1)},
e5(a,b,c,d){return a.removeEventListener(b,A.eM(c,1),!1)}}
A.as.prototype={$ias:1}
A.dG.prototype={
gh(a){return a.length},
j(a,b){if(b>>>0!==b||b>=a.length)throw A.c(A.d6(b,a,null,null,null))
return a[b]},
m(a,b,c){throw A.c(A.a1("Cannot assign element of immutable List."))},
sh(a,b){throw A.c(A.a1("Cannot resize immutable List."))},
L(a,b){return a[b]},
$in:1,
$iae:1,
$iq:1}
A.fa.prototype={
gda(a){var s=a.result
if(t.dI.b(s))return A.kJ(s,0,null)
return s}}
A.fb.prototype={
gh(a){return a.length}}
A.dL.prototype={$idL:1}
A.kt.prototype={
k(a){return String(a)}}
A.aK.prototype={$iaK:1}
A.M.prototype={
k(a){var s=a.nodeValue
return s==null?this.dr(a):s},
$iM:1}
A.b3.prototype={$ib3:1}
A.fM.prototype={
gh(a){return a.length}}
A.aW.prototype={}
A.dh.prototype={$idh:1}
A.bx.prototype={$ibx:1}
A.en.prototype={
gh(a){return a.length},
j(a,b){if(b>>>0!==b||b>=a.length)throw A.c(A.d6(b,a,null,null,null))
return a[b]},
m(a,b,c){throw A.c(A.a1("Cannot assign element of immutable List."))},
sh(a,b){throw A.c(A.a1("Cannot resize immutable List."))},
L(a,b){return a[b]},
$in:1,
$iae:1,
$iq:1}
A.h6.prototype={
a0(){var s,r,q,p,o=A.ks(t.R)
for(s=this.a.className.split(" "),r=s.length,q=0;q<r;++q){p=J.pw(s[q])
if(p.length!==0)o.w(0,p)}return o},
c_(a){this.a.className=a.aj(0," ")},
gh(a){return this.a.classList.length},
gv(a){return this.a.classList.length===0},
gP(a){return this.a.classList.length!==0},
at(a){this.a.className=""},
I(a,b){return typeof b=="string"&&this.a.classList.contains(b)},
w(a,b){var s=this.a.classList,r=s.contains(b)
s.add(b)
return!r},
ax(a,b){var s,r,q
if(typeof b=="string"){s=this.a.classList
r=s.contains(b)
s.remove(b)
q=r}else q=!1
return q}}
A.op.prototype={}
A.cT.prototype={
aN(a,b,c,d){return A.cU(this.a,this.b,a,!1)},
b9(a,b,c){return this.aN(a,null,b,c)}}
A.ax.prototype={}
A.h8.prototype={
J(){var s=this
if(s.b==null)return $.oi()
s.cE()
s.d=s.b=null
return $.oi()},
d0(a){var s,r=this
if(r.b==null)throw A.c(A.bS("Subscription has been canceled."))
r.cE()
s=A.qR(new A.mJ(a),t.A)
r.d=s
r.cC()},
cC(){var s,r=this,q=r.d,p=q!=null
if(p&&r.a<=0){s=r.b
s.toString
if(p)J.uD(s,r.c,q,!1)}},
cE(){var s,r=this.d
if(r!=null){s=this.b
s.toString
J.uE(s,this.c,r,!1)}}}
A.mI.prototype={
$1(a){return this.a.$1(a)},
$S:20}
A.mJ.prototype={
$1(a){return this.a.$1(a)},
$S:20}
A.bl.prototype={
gD(a){return new A.dI(a,this.gh(a),A.al(a).i("dI<bl.E>"))},
w(a,b){throw A.c(A.a1("Cannot add to immutable List."))}}
A.dI.prototype={
p(){var s=this,r=s.c+1,q=s.b
if(r<q){s.d=J.ps(s.a,r)
s.c=r
return!0}s.d=null
s.c=q
return!1},
gt(){return this.d},
$iR:1}
A.h3.prototype={}
A.ha.prototype={}
A.hb.prototype={}
A.ht.prototype={}
A.hu.prototype={}
A.f7.prototype={
bH(a){var s=$.rg().b
if(typeof a!="string")A.a3(A.bA(a))
if(s.test(a))return a
throw A.c(A.eX(a,"value","Not a valid class token"))},
k(a){return this.a0().aj(0," ")},
gD(a){var s=this.a0()
return A.wo(s,s.r,A.D(s).c)},
ak(a,b,c){var s=this.a0()
return new A.bi(s,b,A.D(s).i("@<a4.E>").G(c).i("bi<1,2>"))},
gv(a){return this.a0().a===0},
gP(a){return this.a0().a!==0},
gh(a){return this.a0().a},
I(a,b){if(typeof b!="string")return!1
this.bH(b)
return this.a0().I(0,b)},
w(a,b){var s
this.bH(b)
s=this.cY(new A.i4(b))
return s==null?!1:s},
ax(a,b){var s,r
if(typeof b!="string")return!1
this.bH(b)
s=this.a0()
r=s.ax(0,b)
this.c_(s)
return r},
a1(a,b){var s=this.a0()
return A.oy(s,b,A.D(s).i("a4.E"))},
L(a,b){return this.a0().L(0,b)},
at(a){this.cY(new A.i5())},
cY(a){var s=this.a0(),r=a.$1(s)
this.c_(s)
return r}}
A.i4.prototype={
$1(a){return a.w(0,this.a)},
$S:124}
A.i5.prototype={
$1(a){return a.at(0)},
$S:125}
A.dT.prototype={$idT:1}
A.np.prototype={
$1(a){var s=function(b,c,d){return function(){return b(c,d,this,Array.prototype.slice.apply(arguments))}}(A.x_,a,!1)
A.oJ(s,$.ob(),a)
return s},
$S:4}
A.nq.prototype={
$1(a){return new this.a(a)},
$S:4}
A.nK.prototype={
$1(a){return new A.dR(a)},
$S:30}
A.nL.prototype={
$1(a){return new A.ct(a,t.am)},
$S:31}
A.nM.prototype={
$1(a){return new A.bo(a)},
$S:32}
A.bo.prototype={
j(a,b){if(typeof b!="string"&&typeof b!="number")throw A.c(A.an("property is not a String or num",null))
return A.oH(this.a[b])},
m(a,b,c){if(typeof b!="string"&&typeof b!="number")throw A.c(A.an("property is not a String or num",null))
this.a[b]=A.oI(c)},
N(a,b){if(b==null)return!1
return b instanceof A.bo&&this.a===b.a},
k(a){var s,r
try{s=String(this.a)
return s}catch(r){s=this.dB(0)
return s}},
cG(a,b){var s=this.a,r=b==null?null:A.ov(new A.a8(b,A.ye(),A.a2(b).i("a8<1,@>")),t.z)
return A.oH(s[a].apply(s,r))},
gC(a){return 0}}
A.dR.prototype={}
A.ct.prototype={
cc(a){var s=this,r=a<0||a>=s.gh(s)
if(r)throw A.c(A.a0(a,0,s.gh(s),null,null))},
j(a,b){if(A.aX(b))this.cc(b)
return this.dv(0,b)},
m(a,b,c){this.cc(b)
this.c4(0,b,c)},
gh(a){var s=this.a.length
if(typeof s==="number"&&s>>>0===s)return s
throw A.c(A.bS("Bad JsArray length"))},
sh(a,b){this.c4(0,"length",b)},
w(a,b){this.cG("push",[b])},
$in:1,
$iq:1}
A.dm.prototype={
m(a,b,c){return this.dw(0,b,c)}}
A.f_.prototype={
a0(){var s,r,q,p,o=this.a.getAttribute("class"),n=A.ks(t.R)
if(o==null)return n
for(s=o.split(" "),r=s.length,q=0;q<r;++q){p=J.pw(s[q])
if(p.length!==0)n.w(0,p)}return n},
c_(a){this.a.setAttribute("class",a.aj(0," "))}}
A.l.prototype={
gaH(a){return new A.f_(a)},
gd_(a){return new A.ax(a,"click",!1,t.G)},
gd1(a){return new A.ax(a,"dragenter",!1,t.G)},
gd2(a){return new A.ax(a,"dragleave",!1,t.G)},
gd3(a){return new A.ax(a,"dragover",!1,t.G)},
gd4(a){return new A.ax(a,"drop",!1,t.G)}}
A.ad.prototype={
gcm(){var s,r=this.z
if(r===5121||r===5120){s=this.ch
s=s==="MAT2"||s==="MAT3"}else s=!1
if(!s)r=(r===5123||r===5122)&&this.ch==="MAT3"
else r=!0
return r},
ga9(){var s=B.m.j(0,this.ch)
return s==null?0:s},
gaa(){var s=this,r=s.z
if(r===5121||r===5120){r=s.ch
if(r==="MAT2")return 6
else if(r==="MAT3")return 11
return s.ga9()}else if(r===5123||r===5122){if(s.ch==="MAT3")return 22
return 2*s.ga9()}return 4*s.ga9()},
gao(){var s=this,r=s.fx
if(r!==0)return r
r=s.z
if(r===5121||r===5120){r=s.ch
if(r==="MAT2")return 8
else if(r==="MAT3")return 12
return s.ga9()}else if(r===5123||r===5122){if(s.ch==="MAT3")return 24
return 2*s.ga9()}return 4*s.ga9()},
gaG(){return this.gao()*(this.Q-1)+this.gaa()},
q(a,b){var s,r,q,p=this,o="bufferView",n=a.z,m=p.x,l=p.fr=n.j(0,m),k=l==null
if(!k&&l.Q!==-1)p.fx=l.Q
if(p.z===-1||p.Q===-1||p.ch==null)return
if(m!==-1)if(k)b.l($.T(),A.a([m],t.M),o)
else{l.a$=!0
l=l.Q
if(l!==-1&&l<p.gaa())b.F($.rX(),A.a([p.fr.Q,p.gaa()],t.M))
A.bE(p.y,p.dy,p.gaG(),p.fr,m,b)}m=p.dx
if(m!=null){l=m.d
if(l!==-1)k=!1
else k=!0
if(k)return
k=b.c
k.push("sparse")
s=p.Q
if(l>s)b.l($.tF(),A.a([l,s],t.M),"count")
s=m.f
r=s.d
s.f=n.j(0,r)
k.push("indices")
q=m.e
m=q.d
if(m!==-1){n=q.r=n.j(0,m)
if(n==null)b.l($.T(),A.a([m],t.M),o)
else{n.S(B.o,o,b)
if(q.r.Q!==-1)b.n($.of(),o)
n=q.f
if(n!==-1)A.bE(q.e,A.bb(n),A.bb(n)*l,q.r,m,b)}}k.pop()
k.push("values")
if(r!==-1){n=s.f
if(n==null)b.l($.T(),A.a([r],t.M),o)
else{n.S(B.o,o,b)
if(s.f.Q!==-1)b.n($.of(),o)
n=p.dy
m=B.m.j(0,p.ch)
if(m==null)m=0
A.bE(s.e,n,n*m*l,s.f,r,b)}}k.pop()
k.pop()}},
S(a,b,c){var s
this.a$=!0
s=this.k2
if(s==null)this.k2=a
else if(s!==a)c.l($.rZ(),A.a([s,a],t.M),b)},
eP(a){var s=this.k1
if(s==null)this.k1=a
else if(s!==a)return!1
return!0},
ez(a){var s,r,q=this
if(!q.cx||5126===q.z){a.toString
return a}s=q.dy*8
r=q.z
if(r===5120||r===5122||r===5124)return Math.max(a/(B.c.aA(1,s-1)-1),-1)
else return a/(B.c.aA(1,s)-1)}}
A.fZ.prototype={
ab(){var s=this
return A.c2(function(){var r=0,q=2,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
return function $async$ab(a1,a2){if(a1===1){p=a2
r=q}while(true)switch(r){case 0:a0=s.z
if(a0===-1||s.Q===-1||s.ch==null){r=1
break}o=s.ga9()
n=s.Q
m=s.fr
if(m!=null){m=m.cx
if((m==null?null:m.Q)==null){r=1
break}if(s.gao()<s.gaa()){r=1
break}m=s.y
l=s.dy
if(!A.bE(m,l,s.gaG(),s.fr,null,null)){r=1
break}k=s.fr
j=A.py(a0,k.cx.Q.buffer,k.y+m,B.c.as(s.gaG(),l))
if(j==null){r=1
break}i=j.length
if(s.gcm()){m=B.c.as(s.gao(),l)
l=s.ch==="MAT2"
k=l?8:12
h=l?2:3
g=new A.mw(i,j,h,h,m-k).$0()}else g=new A.mx(j).$3(i,o,B.c.as(s.gao(),l)-o)}else g=A.pK(n*o,new A.my(),t.e)
m=s.dx
if(m!=null){l=m.f
k=l.e
if(k!==-1){f=l.f
if(f!=null)if(f.z!==-1)if(f.y!==-1){f=f.cx
if((f==null?null:f.Q)!=null){f=m.e
if(f.f!==-1)if(f.e!==-1){f=f.r
if(f!=null)if(f.z!==-1)if(f.y!==-1){f=f.cx
f=(f==null?null:f.Q)==null}else f=!0
else f=!0
else f=!0}else f=!0
else f=!0}else f=!0}else f=!0
else f=!0
else f=!0}else f=!0
if(f){r=1
break}f=m.d
if(f>n){r=1
break}n=m.e
m=n.e
e=n.f
if(A.bE(m,A.bb(e),A.bb(e)*f,n.r,null,null)){d=s.dy
c=B.m.j(0,s.ch)
if(c==null)c=0
c=!A.bE(k,d,d*c*f,l.f,null,null)
d=c}else d=!0
if(d){r=1
break}n=n.r
b=A.oo(e,n.cx.Q.buffer,n.y+m,f)
l=l.f
a=A.py(a0,l.cx.Q.buffer,l.y+k,f*o)
if(b==null||a==null){r=1
break}g=new A.mz(s,b,g,o,a).$0()}r=3
return A.mX(g)
case 3:case 1:return A.bY()
case 2:return A.bZ(p)}}},t.e)},
bh(){var s=this
return A.c2(function(){var r=0,q=1,p,o,n,m,l
return function $async$bh(a,b){if(a===1){p=b
r=q}while(true)switch(r){case 0:m=s.dy*8
l=s.z
l=l===5120||l===5122||l===5124
o=t.F
r=l?2:4
break
case 2:l=B.c.aA(1,m-1)
n=s.ab()
n.toString
r=5
return A.mX(A.kw(n,new A.mu(1/(l-1)),n.$ti.i("t.E"),o))
case 5:r=3
break
case 4:l=B.c.aA(1,m)
n=s.ab()
n.toString
r=6
return A.mX(A.kw(n,new A.mv(1/(l-1)),n.$ti.i("t.E"),o))
case 6:case 3:return A.bY()
case 1:return A.bZ(p)}}},t.F)}}
A.mw.prototype={
$0(){var s=this
return A.c2(function(){var r=0,q=1,p,o,n,m,l,k,j,i,h
return function $async$$0(a,b){if(a===1){p=b
r=q}while(true)switch(r){case 0:o=s.a,n=s.c,m=s.b,l=s.d,k=s.e,j=0,i=0,h=0
case 2:if(!(j<o)){r=3
break}r=4
return m[j]
case 4:++j;++i
if(i===n){j+=4-i;++h
if(h===l){j+=k
h=0}i=0}r=2
break
case 3:return A.bY()
case 1:return A.bZ(p)}}},t.e)},
$S:21}
A.mx.prototype={
$3(a,b,c){return this.dm(a,b,c)},
dm(a,b,c){var s=this
return A.c2(function(){var r=a,q=b,p=c
var o=0,n=1,m,l,k,j
return function $async$$3(d,e){if(d===1){m=e
o=n}while(true)switch(o){case 0:l=s.a,k=0,j=0
case 2:if(!(k<r)){o=3
break}o=4
return l[k]
case 4:++k;++j
if(j===q){k+=p
j=0}o=2
break
case 3:return A.bY()
case 1:return A.bZ(m)}}},t.e)},
$S:35}
A.my.prototype={
$1(a){return 0},
$S:36}
A.mz.prototype={
$0(){var s=this
return A.c2(function(){var r=0,q=1,p,o,n,m,l,k,j,i,h,g,f
return function $async$$0(a,b){if(a===1){p=b
r=q}while(true)switch(r){case 0:g=s.b
f=g[0]
o=J.ah(s.c),n=s.d,m=s.a.dx,l=s.e,k=0,j=0,i=0
case 2:if(!o.p()){r=3
break}h=o.gt()
if(j===n){if(k===f&&i!==m.d-1){++i
f=g[i]}++k
j=0}r=k===f?4:6
break
case 4:r=7
return l[i*n+j]
case 7:r=5
break
case 6:r=8
return h
case 8:case 5:++j
r=2
break
case 3:return A.bY()
case 1:return A.bZ(p)}}},t.e)},
$S:21}
A.mu.prototype={
$1(a){return Math.max(a*this.a,-1)},
$S:9}
A.mv.prototype={
$1(a){return a*this.a},
$S:9}
A.fY.prototype={
ab(){var s=this
return A.c2(function(){var r=0,q=2,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
return function $async$ab(a1,a2){if(a1===1){p=a2
r=q}while(true)switch(r){case 0:a0=s.z
if(a0===-1||s.Q===-1||s.ch==null){r=1
break}o=s.ga9()
n=s.Q
m=s.fr
if(m!=null){m=m.cx
if((m==null?null:m.Q)==null){r=1
break}if(s.gao()<s.gaa()){r=1
break}m=s.y
l=s.dy
if(!A.bE(m,l,s.gaG(),s.fr,null,null)){r=1
break}k=s.fr
j=A.px(a0,k.cx.Q.buffer,k.y+m,B.c.as(s.gaG(),l))
if(j==null){r=1
break}i=j.length
if(s.gcm()){m=B.c.as(s.gao(),l)
l=s.ch==="MAT2"
k=l?8:12
h=l?2:3
g=new A.mq(i,j,h,h,m-k).$0()}else g=new A.mr(j).$3(i,o,B.c.as(s.gao(),l)-o)}else g=A.pK(n*o,new A.ms(),t.F)
m=s.dx
if(m!=null){l=m.f
k=l.e
if(k!==-1){f=l.f
if(f!=null)if(f.z!==-1)if(f.y!==-1){f=f.cx
if((f==null?null:f.Q)!=null){f=m.e
if(f.f!==-1)if(f.e!==-1){f=f.r
if(f!=null)if(f.z!==-1)if(f.y!==-1){f=f.cx
f=(f==null?null:f.Q)==null}else f=!0
else f=!0
else f=!0}else f=!0
else f=!0}else f=!0}else f=!0
else f=!0
else f=!0}else f=!0
if(f){r=1
break}f=m.d
if(f>n){r=1
break}n=m.e
m=n.e
e=n.f
if(A.bE(m,A.bb(e),A.bb(e)*f,n.r,null,null)){d=s.dy
c=B.m.j(0,s.ch)
if(c==null)c=0
c=!A.bE(k,d,d*c*f,l.f,null,null)
d=c}else d=!0
if(d){r=1
break}n=n.r
b=A.oo(e,n.cx.Q.buffer,n.y+m,f)
l=l.f
a=A.px(a0,l.cx.Q.buffer,l.y+k,f*o)
if(b==null||a==null){r=1
break}g=new A.mt(s,b,g,o,a).$0()}r=3
return A.mX(g)
case 3:case 1:return A.bY()
case 2:return A.bZ(p)}}},t.F)},
bh(){return this.ab()}}
A.mq.prototype={
$0(){var s=this
return A.c2(function(){var r=0,q=1,p,o,n,m,l,k,j,i,h
return function $async$$0(a,b){if(a===1){p=b
r=q}while(true)switch(r){case 0:o=s.a,n=s.c,m=s.b,l=s.d,k=s.e,j=0,i=0,h=0
case 2:if(!(j<o)){r=3
break}r=4
return m[j]
case 4:++j;++i
if(i===n){j+=4-i;++h
if(h===l){j+=k
h=0}i=0}r=2
break
case 3:return A.bY()
case 1:return A.bZ(p)}}},t.F)},
$S:22}
A.mr.prototype={
$3(a,b,c){return this.dl(a,b,c)},
dl(a,b,c){var s=this
return A.c2(function(){var r=a,q=b,p=c
var o=0,n=1,m,l,k,j
return function $async$$3(d,e){if(d===1){m=e
o=n}while(true)switch(o){case 0:l=s.a,k=0,j=0
case 2:if(!(k<r)){o=3
break}o=4
return l[k]
case 4:++k;++j
if(j===q){k+=p
j=0}o=2
break
case 3:return A.bY()
case 1:return A.bZ(m)}}},t.F)},
$S:39}
A.ms.prototype={
$1(a){return 0},
$S:9}
A.mt.prototype={
$0(){var s=this
return A.c2(function(){var r=0,q=1,p,o,n,m,l,k,j,i,h,g,f
return function $async$$0(a,b){if(a===1){p=b
r=q}while(true)switch(r){case 0:g=s.b
f=g[0]
o=J.ah(s.c),n=s.d,m=s.a.dx,l=s.e,k=0,j=0,i=0
case 2:if(!o.p()){r=3
break}h=o.gt()
if(j===n){if(k===f&&i!==m.d-1){++i
f=g[i]}++k
j=0}r=k===f?4:6
break
case 4:r=7
return l[i*n+j]
case 7:r=5
break
case 6:r=8
return h
case 8:case 5:++j
r=2
break
case 3:return A.bY()
case 1:return A.bZ(p)}}},t.F)},
$S:22}
A.c8.prototype={
ges(){var s=this.e,r=s.r,q=r==null?null:r.cx
if((q==null?null:q.Q)==null)return null
return A.oo(s.f,r.cx.Q.buffer,r.y+s.e,this.d)}}
A.c9.prototype={
q(a,b){this.r=a.z.j(0,this.d)}}
A.ca.prototype={
q(a,b){this.f=a.z.j(0,this.d)}}
A.fj.prototype={
a_(a,b,c,d){d.toString
if(d==1/0||d==-1/0||isNaN(d)){a.l($.rn(),A.a([b,d],t.M),this.a)
return!1}return!0}}
A.fr.prototype={
a_(a,b,c,d){var s,r=this
if(b===c||r.b[c]>d)r.b[c]=d
if(d<r.c[c]){s=r.a
s[c]=s[c]+1}return!0},
au(a){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.b,r=s.length,q=j.c,p=j.a,o=j.d,n=t.M,m=0;m<r;++m)if(!J.am(q[m],s[m])){l=$.oZ()
k=o+"/min/"+m
a.l(l,A.a([q[m],s[m]],n),k)
if(p[m]>0){l=$.oX()
k=o+"/min/"+m
a.l(l,A.a([p[m],q[m]],n),k)}}return!0}}
A.fp.prototype={
a_(a,b,c,d){var s,r=this
if(b===c||r.b[c]<d)r.b[c]=d
if(d>r.c[c]){s=r.a
s[c]=s[c]+1}return!0},
au(a){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.b,r=s.length,q=j.c,p=j.a,o=j.d,n=t.M,m=0;m<r;++m)if(!J.am(q[m],s[m])){l=$.oY()
k=o+"/max/"+m
a.l(l,A.a([q[m],s[m]],n),k)
if(p[m]>0){l=$.oW()
k=o+"/max/"+m
a.l(l,A.a([p[m],q[m]],n),k)}}return!0}}
A.fs.prototype={
a_(a,b,c,d){var s,r=this
if(b===c||r.b[c]>d)r.b[c]=d
if(d<r.c[c]){s=r.a
s[c]=s[c]+1}return!0},
au(a){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.b,r=s.length,q=j.c,p=j.a,o=j.d,n=t.M,m=0;m<r;++m)if(!J.am(q[m],s[m])){l=$.oZ()
k=o+"/min/"+m
a.l(l,A.a([q[m],s[m]],n),k)
if(p[m]>0){l=$.oX()
k=o+"/min/"+m
a.l(l,A.a([p[m],q[m]],n),k)}}return!0}}
A.fq.prototype={
a_(a,b,c,d){var s,r=this
if(b===c||r.b[c]<d)r.b[c]=d
if(d>r.c[c]){s=r.a
s[c]=s[c]+1}return!0},
au(a){var s,r,q,p,o,n,m,l,k,j=this
for(s=j.b,r=s.length,q=j.c,p=j.a,o=j.d,n=t.M,m=0;m<r;++m)if(!J.am(q[m],s[m])){l=$.oY()
k=o+"/max/"+m
a.l(l,A.a([q[m],s[m]],n),k)
if(p[m]>0){l=$.oW()
k=o+"/max/"+m
a.l(l,A.a([p[m],q[m]],n),k)}}return!0}}
A.bF.prototype={
q(a,b){var s,r,q,p,o,n=this,m="samplers",l=n.y
if(l==null||n.x==null)return
s=b.c
s.push(m)
l.a4(new A.hK(b,a))
s.pop()
s.push("channels")
n.x.a4(new A.hL(n,b,a))
s.pop()
s.push(m)
for(r=l.b,l=l.a,q=l.length,p=0;p<r;++p){o=p>=q
if(!(o?null:l[p]).a$)b.X($.hG(),p)}s.pop()}}
A.hK.prototype={
$2(a,b){var s,r,q,p,o,n,m="input",l="output",k=this.a,j=k.c
j.push(B.c.k(a))
s=this.b.f
r=b.d
b.r=s.j(0,r)
q=b.f
b.x=s.j(0,q)
if(r!==-1){s=b.r
if(s==null)k.l($.T(),A.a([r],t.M),m)
else{s.S(B.b0,m,k)
p=b.r.fr
if(p!=null){p.S(B.o,m,k)
s=p.Q
if(s!==-1)k.n($.p3(),m)}j.push(m)
o=A.dz(b.r)
if(!o.N(0,B.H))k.F($.t2(),A.a([o,A.a([B.H],t.p)],t.M))
else k.Z(b.r,new A.eV(k.R()))
s=b.r
if(s.db==null||s.cy==null)k.O($.t4())
if(b.e==="CUBICSPLINE"&&b.r.Q<2)k.F($.t3(),A.a(["CUBICSPLINE",2,b.r.Q],t.M))
j.pop()}}if(q!==-1){s=b.x
if(s==null)k.l($.T(),A.a([q],t.M),l)
else{s.S(B.b1,l,k)
n=b.x.fr
if(n!=null){n.S(B.o,l,k)
s=n.Q
if(s!==-1)k.n($.p3(),l)}s=b.x.fr
if(s!=null)s.S(B.o,l,k)
b.x.eP("CUBICSPLINE"===b.e)}}j.pop()},
$S:40}
A.hL.prototype={
$2(a,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d="sampler",c=this.b,b=c.c
b.push(B.c.k(a))
s=this.a
r=a0.d
a0.f=s.y.j(0,r)
q=a0.e
p=q!=null
if(p){o=q.d
q.f=this.c.db.j(0,o)
if(o!==-1){b.push("target")
n=q.f
if(n==null)c.l($.T(),A.a([o],t.M),"node")
else{n.a$=!0
switch(q.e){case"translation":case"rotation":case"scale":if(n.Q!=null)c.O($.t_())
if(q.f.id!=null)c.n($.tG(),"path")
break
case"weights":o=n.fy
o=o==null?e:o.x
o=o==null?e:o.gb7(o)
if((o==null?e:o.fx)==null)c.O($.t0())
break}}b.pop()}}if(r!==-1){o=a0.f
if(o==null)c.l($.T(),A.a([r],t.M),d)
else{o.a$=!0
if(p&&o.x!=null){r=q.e
if(r==="rotation"){m=o.x
if(m.ga9()===4){b.push(d)
o=c.R()
n=5126===m.z?e:m.gbQ()
c.Z(m,new A.e4("CUBICSPLINE"===a0.f.e,n,o,t.ed))
b.pop()}o=a0.f
o.x.toString}l=A.dz(o.x)
k=B.dg.j(0,r)
if((k==null?e:B.d.I(k,l))===!1)c.l($.t6(),A.a([l,k,r],t.M),d)
o=a0.f
n=o.r
if(n!=null&&n.Q!==-1&&o.x.Q!==-1&&o.e!=null){j=n.Q
if(o.e==="CUBICSPLINE")j*=3
if(r==="weights"){r=q.f
r=r==null?e:r.fy
r=r==null?e:r.x
r=r==null?e:r.gb7(r)
r=r==null?e:r.fx
i=r==null?e:r.length
j*=i==null?0:i}if(j!==0&&j!==a0.f.x.Q)c.l($.t5(),A.a([j,a0.f.x.Q],t.M),d)}}}for(h=a+1,s=s.x,r=s.b,o=t.M,s=s.a,n=s.length;h<r;++h){if(p){g=h>=n
f=(g?e:s[h]).e
g=f!=null&&q.d===f.d&&q.e==f.e}else g=!1
if(g)c.l($.t1(),A.a([h],o),"target")}b.pop()}},
$S:41}
A.bd.prototype={}
A.cc.prototype={}
A.be.prototype={}
A.eV.prototype={
a_(a,b,c,d){var s=this
if(d<0)a.l($.rh(),A.a([b,d],t.M),s.b)
else{if(b!==0&&d<=s.a)a.l($.ri(),A.a([b,d,s.a],t.M),s.b)
s.a=d}return!0}}
A.e4.prototype={
a_(a,b,c,d){var s,r,q=this
if(!q.a||4===(q.d&4)){s=q.b
r=s!=null?s.$1(d):d
s=q.e+r*r
q.e=s
if(3===c){if(Math.abs(Math.sqrt(s)-1)>0.00769)a.l($.rj(),A.a([b-3,b,Math.sqrt(q.e)],t.M),q.c)
q.e=0}}if(++q.d===12)q.d=0
return!0}}
A.bG.prototype={
gba(){var s,r=this.f
if(r!=null){s=$.bC().b
s=!s.test(r)}else s=!0
if(s)return 0
return A.cY($.bC().aI(r).b[1],null)},
gbP(){var s,r=this.f
if(r!=null){s=$.bC().b
s=!s.test(r)}else s=!0
if(s)return 0
return A.cY($.bC().aI(r).b[2],null)},
gcW(){var s,r=this.r
if(r!=null){s=$.bC().b
s=!s.test(r)}else s=!0
if(s)return 2
return A.cY($.bC().aI(r).b[1],null)},
gex(){var s,r=this.r
if(r!=null){s=$.bC().b
s=!s.test(r)}else s=!0
if(s)return 0
return A.cY($.bC().aI(r).b[2],null)}}
A.b_.prototype={}
A.bH.prototype={
S(a,b,c){var s
this.a$=!0
s=this.cy
if(s==null){this.cy=a
if(a===B.M||a===B.A)c.n($.t8(),b)}else if(s!==a)c.l($.t9(),A.a([s,a],t.M),b)},
q(a,b){var s,r=this,q=r.x,p=r.cx=a.y.j(0,q)
r.db=r.Q
s=r.ch
if(s===34962)r.cy=B.A
else if(s===34963)r.cy=B.M
if(q!==-1)if(p==null)b.l($.T(),A.a([q],t.M),"buffer")
else{p.a$=!0
p=p.y
if(p!==-1){s=r.y
if(s>=p)b.l($.p4(),A.a([q,p],t.M),"byteOffset")
else if(s+r.z>p)b.l($.p4(),A.a([q,p],t.M),"byteLength")}}}}
A.bI.prototype={}
A.cf.prototype={}
A.cg.prototype={}
A.dJ.prototype={
eQ(a){var s,r,q,p,o
new A.jf(this,a).$1(this.fy)
s=a.r
for(r=s.length,q=a.c,p=0;p<s.length;s.length===r||(0,A.cZ)(s),++p){o=s[p]
B.d.sh(q,0)
B.d.H(q,o.b)
o.a.bY(this,a)}B.d.sh(q,0)}}
A.jc.prototype={
$0(){B.d.sh(this.a.c,0)
return null},
$S:1}
A.jd.prototype={
$1$2(a,b,c){var s,r,q,p,o,n,m,l,k,j=this,i=j.a
if(!i.B(a)){i=J.bm(0,c.i("0*"))
return new A.H(i,0,a,c.i("H<0*>"))}j.b.$0()
s=i.j(0,a)
if(t.m.b(s)){i=J.S(s)
r=j.c
q=c.i("0*")
if(i.gP(s)){p=i.gh(s)
q=A.W(p,null,!1,q)
o=r.c
o.push(a)
for(n=t.M,m=t.t,l=0;l<i.gh(s);++l){k=i.j(s,l)
if(m.b(k)){o.push(B.c.k(l))
q[l]=b.$2(k,r)
o.pop()}else r.an($.ac(),A.a([k,"object"],n),l)}return new A.H(q,p,a,c.i("H<0*>"))}else{r.n($.c7(),a)
i=J.bm(0,q)
return new A.H(i,0,a,c.i("H<0*>"))}}else{j.c.l($.ac(),A.a([s,"array"],t.M),a)
i=J.bm(0,c.i("0*"))
return new A.H(i,0,a,c.i("H<0*>"))}},
$2(a,b){return this.$1$2(a,b,t.z)},
$S:42}
A.je.prototype={
$1$3$req(a,b,c,d){var s,r
this.a.$0()
s=this.c
r=A.oS(this.b,a,s,!0)
if(r==null)return null
s.c.push(a)
return b.$2(r,s)},
$2(a,b){return this.$1$3$req(a,b,!1,t.z)},
$1$2(a,b,c){return this.$1$3$req(a,b,!1,c)},
$S:43}
A.ja.prototype={
$2(a,b){var s,r,q,p,o,n=this.a,m=n.c
m.push(a.c)
s=this.b
a.a4(new A.jb(n,s))
r=n.f.j(0,b)
if(r!=null){q=J.d7(m.slice(0),A.a2(m).c)
for(p=J.ah(r);p.p();){o=p.gt()
B.d.sh(m,0)
B.d.H(m,o.b)
o.a.q(s,n)}B.d.sh(m,0)
B.d.H(m,q)}m.pop()},
$S:44}
A.jb.prototype={
$2(a,b){var s=this.a,r=s.c
r.push(B.c.k(a))
b.q(this.b,s)
r.pop()},
$S:45}
A.j8.prototype={
$2(a,b){var s,r
if(t.c.b(b)){s=this.a
r=s.c
r.push(a)
b.q(this.b,s)
r.pop()}},
$S:5}
A.j9.prototype={
$2(a,b){var s,r,q,p=this
if(!b.k1)if(b.fx==null)if(b.fy==null)if(b.fr==null){s=b.a
s=s.gv(s)&&b.b==null}else s=!1
else s=!1
else s=!1
else s=!1
if(s)p.a.X($.u2(),a)
if(b.go!=null){s=p.b
s.at(0)
for(r=b;r.go!=null;)if(s.w(0,r))r=r.go
else{if(r===b)p.a.X($.tl(),a)
break}}if(b.id!=null){if(b.go!=null)p.a.X($.u7(),a)
s=b.Q
if(s==null||s.cU()){s=b.cx
if(s!=null){s=s.a
s=s[0]===0&&s[1]===0&&s[2]===0}else s=!0
if(s){s=b.cy
if(s!=null){s=s.a
s=s[0]===0&&s[1]===0&&s[2]===0&&s[3]===1}else s=!0
if(s){s=b.db
if(s!=null){s=s.a
s=s[0]===1&&s[1]===1&&s[2]===1}else s=!0}else s=!1}else s=!1}else s=!1
if(!s)p.a.X($.u6(),a)
q=b.id.cy.av(0,new A.j6(),new A.j7())
if(q!=null){s=q.dy
s=!b.dy.b6(0,s.gcH(s))}else s=!1
if(s)p.a.X($.u5(),a)}},
$S:47}
A.j6.prototype={
$1(a){return a.go==null},
$S:29}
A.j7.prototype={
$0(){return null},
$S:2}
A.jf.prototype={
$1(a){var s=this.b,r=s.c
B.d.sh(r,0)
r.push(a.c)
a.a4(new A.jg(this.a,s))
r.pop()},
$S:49}
A.jg.prototype={
$2(a,b){var s=this.b,r=s.c
r.push(B.c.k(a))
b.bY(this.a,s)
r.pop()},
$S:50}
A.r.prototype={}
A.p.prototype={
q(a,b){},
$iu:1}
A.fd.prototype={}
A.hd.prototype={}
A.b1.prototype={
q(a,b){var s,r="bufferView",q=this.x
if(q!==-1){s=this.ch=a.z.j(0,q)
if(s==null)b.l($.T(),A.a([q],t.M),r)
else{s.S(B.b5,r,b)
if(this.ch.Q!==-1)b.n($.ta(),r)}}},
eO(){var s,r=this.ch,q=r==null?null:r.cx
if((q==null?null:q.Q)!=null)try{this.Q=A.kJ(r.cx.Q.buffer,r.y,r.z)}catch(s){if(!(A.X(s) instanceof A.aN))throw s}}}
A.aE.prototype={
q(a,b){var s=this,r=new A.kx(b,a)
r.$2(s.x,"pbrMetallicRoughness")
r.$2(s.y,"normalTexture")
r.$2(s.z,"occlusionTexture")
r.$2(s.Q,"emissiveTexture")}}
A.kx.prototype={
$2(a,b){var s,r
if(a!=null){s=this.a
r=s.c
r.push(b)
a.q(this.b,s)
r.pop()}},
$S:51}
A.cO.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("baseColorTexture")
r.q(a,b)
s.pop()}r=this.x
if(r!=null){s=b.c
s.push("metallicRoughnessTexture")
r.q(a,b)
s.pop()}}}
A.cN.prototype={}
A.cM.prototype={
q(a,b){var s,r
this.dC(a,b)
for(s=b.e,r=this;r!=null;){r=s.j(0,r)
if(r instanceof A.aE){r.dx=!0
break}}}}
A.bt.prototype={
q(a,b){var s,r=this,q=r.d,p=r.f=a.fy.j(0,q)
if(q!==-1)if(p==null)b.l($.T(),A.a([q],t.M),"index")
else p.a$=!0
for(q=b.e,s=r;s!=null;){s=q.j(0,s)
if(s instanceof A.aE){s.dy.m(0,b.R(),r.e)
break}}}}
A.ce.prototype={
k(a){return this.a}}
A.cb.prototype={
k(a){return this.a}}
A.B.prototype={
k(a){var s="{"+A.b(this.a)+", "+A.b(B.ay.j(0,this.b))
return s+(this.c?" normalized":"")+"}"},
N(a,b){if(b==null)return!1
return b instanceof A.B&&b.a==this.a&&b.b===this.b&&b.c===this.c},
gC(a){return A.qD(A.hy(A.hy(A.hy(0,J.d0(this.a)),B.c.gC(this.b)),B.bV.gC(this.c)))}}
A.b2.prototype={
q(a,b){var s,r=b.c
r.push("primitives")
s=this.x
if(s!=null)s.a4(new A.kH(b,a))
r.pop()}}
A.kH.prototype={
$2(a,b){var s,r=this.a,q=r.c
q.push(B.c.k(a))
q.push("extensions")
s=this.b
b.a.K(0,new A.kG(r,s))
q.pop()
b.q(s,r)
q.pop()},
$S:23}
A.kG.prototype={
$2(a,b){var s,r
if(t.c.b(b)){s=this.a
r=s.c
r.push(a)
b.q(this.b,s)
r.pop()}},
$S:5}
A.aJ.prototype={
geL(){switch(this.r){case 4:return B.c.b3(this.dy,3)
case 5:case 6:var s=this.dy
return s>2?s-2:0
default:return 0}},
q(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="attributes",d="indices",c=f.d
if(c!=null){s=b.c
s.push(e)
c.K(0,new A.kC(f,a,b))
s.pop()}c=f.e
if(c!==-1){s=f.fy=a.f.j(0,c)
if(s==null)b.l($.T(),A.a([c],t.M),d)
else{f.dy=s.Q
s.S(B.b3,d,b)
c=f.fy.fr
if(c!=null)c.S(B.M,d,b)
c=b.c
c.push(d)
s=f.fy.fr
if(s!=null&&s.Q!==-1)b.O($.th())
r=A.dz(f.fy)
if(!B.d.I(B.ap,r))b.F($.tg(),A.a([r,B.ap],t.M))
else{s=f.fr
q=s!==-1?s-1:-1
s=f.r
p=s!==-1?B.c.aA(1,s):-1
if(p!==0&&q>=-1){s=f.fy
o=b.R()
n=B.c.b3(f.dy,3)
m=f.fy.z
l=new Uint32Array(3)
b.Z(s,new A.fg(q,n,A.rd(m),16===(p&16),l,o))}}c.pop()}}c=f.dy
if(c!==-1){s=f.r
if(!(s===1&&c%2!==0))if(!((s===2||s===3)&&c<2))if(!(s===4&&c%3!==0))c=(s===5||s===6)&&c<3
else c=!0
else c=!0
else c=!0}else c=!1
if(c)b.F($.tf(),A.a([f.dy,B.co[f.r]],t.M))
c=f.f
s=f.go=a.cx.j(0,c)
if(c!==-1)if(s==null)b.l($.T(),A.a([c],t.M),"material")
else{s.a$=!0
s.dy.K(0,new A.kD(f,b))}if(f.Q){c=f.go
c=c==null||!c.dx}else c=!1
if(c){c=b.c
c.push(e)
b.n($.tw(),"TANGENT")
c.pop()}for(c=f.id,s=B.d.gD(c),c=new A.cS(s,new A.kE(),A.a2(c).i("cS<1>")),o=b.c;c.p();){n=s.gt()
o.push(e)
b.n($.hG(),"TEXCOORD_"+A.b(n))
o.pop()}c=f.x
if(c!=null){s=b.c
s.push("targets")
k=c.length
j=J.pL(k,t.gj)
for(o=t.X,n=t.W,i=0;i<k;++i)j[i]=A.ai(o,n)
f.fx=j
for(h=0;h<c.length;++h){g=c[h]
s.push(B.c.k(h))
g.K(0,new A.kF(f,a,b,h))
s.pop()}s.pop()}},
cb(a,b,c){var s,r=a.fr
if(r.Q===-1){s=c.x.bT(r,new A.kB())
if(s.w(0,a)&&s.gh(s)>1)c.n($.td(),b)}}}
A.ky.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(a.length!==0&&B.a.E(a,0)===95)return
switch(a){case"POSITION":e.a.c=!0
break
case"NORMAL":e.a.b=!0
break
case"TANGENT":e.a.a=!0
break
default:s=a.split("_")
r=s[0]
if(!B.d.I(B.ce,r)||s.length!==2){e.b.n($.og(),a)
break}q=s[1]
q.toString
p=new A.d2(q)
if(p.gh(p)===0){o=0
n=!1}else{m=q.length
if(m===1){o=B.a.E(q,0)-48
n=!(o<0||o>9)||!1}else{o=0
l=0
while(!0){if(!(l<m)){n=!0
break}k=B.a.E(q,l)-48
if(k<=9)if(k>=0)j=l===0&&k===0
else j=!0
else j=!0
if(j){n=!1
break}o=10*o+k;++l}}}if(n)switch(r){case"COLOR":q=e.a;++q.d
i=q.e
q.e=o>i?o:i
break
case"JOINTS":q=e.a;++q.f
h=q.r
q.r=o>h?o:h
break
case"TEXCOORD":q=e.a;++q.z
g=q.Q
q.Q=o>g?o:g
break
case"WEIGHTS":q=e.a;++q.x
f=q.y
q.y=o>f?o:f
break}else e.b.n($.og(),a)}},
$S:24}
A.kz.prototype={
$3(a,b,c){var s=a+1
if(s!==b){this.a.F($.tV(),A.a([c,s,b],t.M))
return 0}return b},
$S:54}
A.kA.prototype={
$1(a){var s=this.a
if(!s.k3.B(a)&&!J.uK(a,"_"))s.n($.og(),a)},
$S:24}
A.kC.prototype={
$2(a,b){var s,r,q,p,o,n,m,l=this
if(b===-1)return
s=l.b.f.j(0,b)
if(s==null){l.c.l($.T(),A.a([b],t.M),a)
return}r=l.a
r.dx.m(0,a,s)
q=l.c
s.S(B.a6,a,q)
p=s.fr
if(p!=null)p.S(B.A,a,q)
if(a==="POSITION")p=s.db==null||s.cy==null
else p=!1
if(p)q.n($.p7(),"POSITION")
o=A.dz(s)
n=q.k2.j(0,A.a(a.split("_"),t.s)[0])
if(n!=null){if(!n.I(0,o))q.l($.p6(),A.a([o,n],t.M),a)
else if(a==="NORMAL"){p=q.c
p.push("NORMAL")
m=q.R()
q.Z(s,new A.fS(m,5126===s.z?null:s.gbQ()))
p.pop()}else if(a==="TANGENT"){p=q.c
p.push("TANGENT")
m=q.R()
q.Z(s,new A.fT(m,5126===s.z?null:s.gbQ()))
p.pop()}else if(a==="COLOR_0"&&5126===s.z){p=q.c
p.push(a)
q.Z(s,new A.f1(q.R()))
p.pop()}}else if(s.z===5125)q.n($.te(),a)
p=s.y
if(!(p!==-1&&p%4!==0))if(s.gaa()%4!==0){p=s.fr
p=p!=null&&p.Q===-1}else p=!1
else p=!0
if(p)q.n($.p5(),a)
p=r.fr
if(p===-1)r.dy=r.fr=s.Q
else if(p!==s.Q)q.n($.tk(),a)
p=s.fr
if(p!=null&&p.Q===-1){if(p.db===-1)p.db=s.gaa()
r.cb(s,a,q)}},
$S:6}
A.kD.prototype={
$2(a,b){var s
if(b!==-1){s=this.a
if(b+1>s.db)this.b.l($.p8(),A.a([a,b],t.M),"material")
else s.id[b]=-1}},
$S:6}
A.kE.prototype={
$1(a){return a!==-1},
$S:10}
A.kF.prototype={
$2(a,b){var s,r,q,p,o,n,m=this
if(b===-1)return
s=m.b.f.j(0,b)
if(s==null)m.c.l($.T(),A.a([b],t.M),a)
else{r=m.c
s.S(B.a6,a,r)
q=s.fr
if(q!=null)q.S(B.A,a,r)
p=m.a.dx.j(0,a)
if(p==null)r.n($.tj(),a)
else if(p.Q!==s.Q)r.n($.ti(),a)
if(a==="POSITION")q=s.db==null||s.cy==null
else q=!1
if(q)r.n($.p7(),"POSITION")
o=A.dz(s)
n=r.k3.j(0,a)
if(n!=null&&!n.I(0,o))r.l($.p6(),A.a([o,n],t.M),a)
q=s.y
if(!(q!==-1&&q%4!==0))if(s.gaa()%4!==0){q=s.fr
q=q!=null&&q.Q===-1}else q=!1
else q=!0
if(q)r.n($.p5(),a)
q=s.fr
if(q!=null&&q.Q===-1){if(q.db===-1)q.db=s.gaa()
m.a.cb(s,a,r)}}m.a.fx[m.d].m(0,a,s)},
$S:6}
A.kB.prototype={
$0(){return A.aQ(t.W)},
$S:57}
A.fg.prototype={
a_(a,b,c,d){var s,r,q=this,p=q.a
if(d>p)a.l($.rk(),A.a([b,d,p],t.M),q.cy)
if(d===q.c)a.l($.rl(),A.a([d,b],t.M),q.cy)
if(q.x){p=q.cx
s=q.Q
p[s]=d;++s
q.Q=s
if(s===3){q.Q=0
s=p[0]
r=p[1]
if(s!==r){p=p[2]
p=r===p||p===s}else p=!0
if(p)++q.ch}}return!0},
au(a){var s=this.ch
if(s>0)a.l($.rm(),A.a([s,this.b],t.M),this.cy)
return!0}}
A.at.prototype={
q(a,b){var s,r,q,p=this,o=p.x
p.fr=a.Q.j(0,o)
s=p.z
p.id=a.fx.j(0,s)
r=p.ch
p.fy=a.cy.j(0,r)
if(o!==-1){q=p.fr
if(q==null)b.l($.T(),A.a([o],t.M),"camera")
else q.a$=!0}if(s!==-1){o=p.id
if(o==null)b.l($.T(),A.a([s],t.M),"skin")
else o.a$=!0}if(r!==-1){o=p.fy
if(o==null)b.l($.T(),A.a([r],t.M),"mesh")
else{o.a$=!0
o=o.x
if(o!=null){s=p.dx
r=s==null
if(!r){o=o.j(0,0).fx
o=o==null?null:o.length
o=o!==s.length}else o=!1
if(o){o=$.tp()
s=s.length
q=p.fy.x.j(0,0).fx
b.l(o,A.a([s,q==null?null:q.length],t.M),"weights")}if(r&&p.fy.y!=null)p.fy.z=!0
if(p.id!=null){o=p.fy.x
if(o.b6(o,new A.kL()))b.O($.tn())}else{o=p.fy.x
if(o.aF(o,new A.kM()))b.O($.to())}}}}o=p.y
if(o!=null){s=A.W(o.gh(o),null,!1,t.L)
p.fx=s
A.oV(o,s,a.db,"children",b,new A.kN(p,b))}},
c7(a,b){var s,r,q,p,o=this
o.dy.w(0,a)
if(o.fx==null||!b.w(0,o))return
for(s=o.fx,r=s.length,q=0;q<r;++q){p=s[q]
if(p!=null)p.c7(a,b)}}}
A.kL.prototype={
$1(a){return a.cx===0},
$S:7}
A.kM.prototype={
$1(a){return a.cx!==0},
$S:7}
A.kN.prototype={
$3(a,b,c){if(a.go!=null)this.b.an($.tm(),A.a([b],t.M),c)
a.go=this.a},
$S:11}
A.bO.prototype={}
A.bP.prototype={
q(a,b){var s,r=this.x
if(r==null)return
s=A.W(r.gh(r),null,!1,t.L)
this.y=s
A.oV(r,s,a.db,"nodes",b,new A.kY(this,b))}}
A.kY.prototype={
$3(a,b,c){if(a.go!=null)this.b.an($.tq(),A.a([b],t.M),c)
a.c7(this.a,A.aQ(t.L))},
$S:11}
A.bQ.prototype={
q(a,b){var s,r,q,p,o,n=this,m="inverseBindMatrices",l="skeleton",k=n.x
n.Q=a.f.j(0,k)
s=a.db
r=n.y
n.cx=s.j(0,r)
q=n.z
if(q!=null){p=A.W(q.gh(q),null,!1,t.L)
n.ch=p
A.oV(q,p,s,"joints",b,new A.m2(n))
if(n.cy.a===0)b.n($.ub(),"joints")}if(k!==-1){s=n.Q
if(s==null)b.l($.T(),A.a([k],t.M),m)
else{s.S(B.b2,m,b)
k=n.Q.fr
if(k!=null)k.S(B.b4,m,b)
k=b.c
k.push(m)
s=n.Q.fr
if(s!=null&&s.Q!==-1)b.O($.tr())
o=A.dz(n.Q)
if(!o.N(0,B.X))b.F($.ts(),A.a([o,A.a([B.X],t.p)],t.M))
else b.Z(n.Q,new A.ff(b.R()))
s=n.ch
if(s!=null&&n.Q.Q<s.length)b.F($.tb(),A.a([s.length,n.Q.Q],t.M))
k.pop()}}if(r!==-1){k=n.cx
if(k==null)b.l($.T(),A.a([r],t.M),l)
else if(!n.cy.I(0,k))b.n($.uc(),l)}}}
A.m2.prototype={
$3(a,b,c){var s,r,q
a.k1=!0
s=A.aQ(t.L)
r=a
while(!0){if(!(r!=null&&s.w(0,r)))break
r=r.go}q=this.a.cy
if(q.a===0)q.H(0,s)
else q.dP(s.gcH(s),!1)},
$S:11}
A.ff.prototype={
a_(a,b,c,d){var s
if(!(3===c&&0!==d))if(!(7===c&&0!==d))if(!(11===c&&0!==d))s=15===c&&1!==d
else s=!0
else s=!0
else s=!0
if(s)a.l($.ro(),A.a([b,c,d],t.M),this.a)
return!0}}
A.bT.prototype={
q(a,b){var s,r,q=this,p=q.y
q.Q=a.ch.j(0,p)
s=q.x
q.z=a.dx.j(0,s)
if(p!==-1){r=q.Q
if(r==null)b.l($.T(),A.a([p],t.M),"source")
else r.a$=!0}if(s!==-1){p=q.z
if(p==null)b.l($.T(),A.a([s],t.M),"sampler")
else p.a$=!0}},
bY(a,b){var s=this.Q,r=s==null,q=r?null:s.y
if(q==null){s=r?null:s.cx
q=s==null?null:s.a}if(q!=null&&!B.d.I(B.ao,q))b.l($.p9(),A.a([q,B.ao],t.M),"source")},
$icP:1}
A.ml.prototype={}
A.i.prototype={
Z(a,b){J.oj(this.d.bT(a,new A.hW()),b)},
T(a,b){var s,r,q
for(s=J.ah(b),r=this.e;s.p();){q=s.gt()
if(q!=null)r.m(0,q,a)}},
gen(){var s=this.fy
return new A.ed(s,new A.hY(),A.a2(s).i("ed<1>"))},
c1(a){var s,r,q,p=this.c
if(p.length===0&&a!=null&&B.a.V(a,"/"))return a
s=a!=null
if(s)p.push(a)
r=this.go
q=r.a+="/"
r.a=A.oz(q,new A.a8(p,new A.hZ(),A.a2(p).i("a8<1,d*>")),"/")
if(s)p.pop()
p=r.a
r.a=""
return p.charCodeAt(0)==0?p:p},
R(){return this.c1(null)},
eu(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="/extensionsUsed/"
B.d.H(f.cx,a)
for(s=J.S(a),r=f.db,q=f.fx,p=B.dy.a,o=t.M,n=J.S(b),m=0;m<s.gh(a);++m){l=s.j(a,m)
k=$.rf().aI(l)
j=k==null?null:k.b[1]
if(j==null)f.n($.tK(),e+m)
else if(!p.B(j)){k=$.uf()
i=e+m
f.l(k,A.a([j],o),i)}h=q.av(0,new A.i1(l),new A.i2(l))
if(h==null){k=$.tv()
i=e+m
f.l(k,A.a([l],o),i)
continue}h.b.K(0,new A.i3(f,h))
k=h.c
if(k!=null)k.$1(f)
k=h.d&&!n.I(b,l)
if(k){k=$.u9()
i=e+m
f.l(k,A.a([l],o),i)}r.push(l)}for(m=0;m<n.gh(b);++m){g=n.j(b,m)
if(!s.I(a,g)){r=$.ug()
q="/extensionsRequired/"+m
f.l(r,A.a([g],o),q)}}},
a8(a,b,c,d,e,f){var s,r=this,q=null,p=r.b
if(p.b.I(0,a.b))return
p=p.a
if(p>0&&r.fy.length===p){r.z=!0
throw A.c(B.b9)}if(f!=null)r.fy.push(new A.bJ(a,q,q,f,b))
else{s=c!=null?B.c.k(c):d
p=e?"":r.c1(s)
r.fy.push(new A.bJ(a,q,p,q,b))}},
n(a,b){return this.a8(a,null,null,b,!1,null)},
F(a,b){return this.a8(a,b,null,null,!1,null)},
l(a,b,c){return this.a8(a,b,null,c,!1,null)},
an(a,b,c){return this.a8(a,b,c,null,!1,null)},
X(a,b){return this.a8(a,null,b,null,!1,null)},
aE(a,b){return this.a8(a,null,null,null,!1,b)},
a3(a,b,c){return this.a8(a,b,null,null,!1,c)},
b4(a,b,c){return this.a8(a,b,null,null,c,null)},
O(a){return this.a8(a,null,null,null,!1,null)}}
A.hX.prototype={
$1(a){return a.a},
$S:60}
A.hW.prototype={
$0(){return A.a([],t.gd)},
$S:61}
A.hY.prototype={
$1(a){return a.gbl()===B.b},
$S:62}
A.hZ.prototype={
$1(a){var s
a.toString
s=A.rc(a,"~","~0")
return A.rc(s,"/","~1")},
$S:63}
A.i1.prototype={
$1(a){return a.a===this.a},
$S:25}
A.i2.prototype={
$0(){return B.d.av(B.as,new A.i_(this.a),new A.i0())},
$S:65}
A.i_.prototype={
$1(a){return a.a===this.a},
$S:25}
A.i0.prototype={
$0(){return null},
$S:2}
A.i3.prototype={
$2(a,b){this.a.Q.m(0,new A.cn(a,this.b.a),b)},
$S:66}
A.cr.prototype={$iao:1}
A.d5.prototype={
k(a){return"ImageCodec."+this.b}}
A.eg.prototype={
k(a){return"_ColorPrimaries."+this.b}}
A.di.prototype={
k(a){return"_ColorTransfer."+this.b}}
A.co.prototype={
k(a){return"Format."+this.b}}
A.cq.prototype={}
A.ji.prototype={
$1(a){var s,r,q,p=this.a
if(!p.c){s=A.pJ(a)
r=p.a
q=this.b
switch(s){case B.af:p.b=new A.jt(q,r)
break
case B.ag:s=new Uint8Array(13)
p.b=new A.kP(B.u,B.r,s,new Uint8Array(32),q,r)
break
case B.ah:p.b=new A.mp(new Uint8Array(30),q,r)
break
default:r.J()
q.Y(B.bj)
return}p.c=!0}p.b.w(0,a)},
$S:26}
A.jk.prototype={
$1(a){this.a.a.J()
this.b.Y(a)},
$S:68}
A.jj.prototype={
$0(){var s=this.a.b
s.b.J()
s=s.a
if((s.a.a&30)===0)s.Y(B.bi)},
$S:2}
A.jh.prototype={
cl(a){var s
this.b.J()
s=this.a
if((s.a.a&30)===0)s.Y(a)}}
A.jt.prototype={
w(a,b){var s,r,q
try{this.dX(b)}catch(r){q=A.X(r)
if(q instanceof A.aO){s=q
this.b.J()
this.a.Y(s)}else throw r}},
dX(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=new A.jv(),g=new A.ju()
for(s=J.S(a),r=0,q=0;r!==s.gh(a);){p=s.j(a,r)
switch(i.c){case 0:if(255===p)i.c=255
else throw A.c(B.bU)
break
case 255:if(g.$1(p)){i.c=1
i.d=p
i.e=i.f=0}break
case 1:i.e=p<<8>>>0
i.c=2
break
case 2:o=i.e+p
i.e=o
if(o<2)throw A.c(B.bS)
if(h.$1(i.d)){o=i.e
i.r=new Uint8Array(o-2)}i.c=3
break
case 3:q=Math.min(s.gh(a)-r,i.e-i.f-2)
o=h.$1(i.d)
n=i.f
m=n+q
if(o){o=i.r
i.f=m;(o&&B.j).a5(o,n,m,a,r)
if(i.f===i.e-2){i.b.J()
a=i.r
l=a[0]
s=a[1]
o=a[2]
n=a[3]
m=a[4]
k=a[5]
if(k===3)j=B.p
else if(k===1)j=B.ad
else{A.a3(B.bT)
j=B.P}k=i.a.a
if((k.a&30)!==0)A.a3(A.bS("Future already completed"))
k.ad(new A.cq("image/jpeg",l,j,(n<<8|m)>>>0,(s<<8|o)>>>0,B.r,B.u,!1,!1))
return}}else{i.f=m
if(m===i.e-2)i.c=255}r+=q
continue}++r}}}
A.jv.prototype={
$1(a){return(a&240)===192&&a!==196&&a!==200&&a!==204||a===222},
$S:10}
A.ju.prototype={
$1(a){return!(a===1||(a&248)===208||a===216||a===217||a===255)},
$S:10}
A.kP.prototype={
w(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=new A.kQ(e)
for(s=J.S(b),r=e.dx,q=e.db,p=0,o=0;p!==s.gh(b);){n=s.j(b,p)
switch(e.y){case 0:p+=8
e.y=1
continue
case 1:e.c=(e.c<<8|n)>>>0
if(++e.d===4)e.y=2
break
case 2:m=(e.e<<8|n)>>>0
e.e=m
if(++e.f===4){switch(m){case 1229472850:if(e.c!==13){e.b.J()
s=e.a
if((s.a.a&30)===0)s.Y(B.q)
return}e.z=!0
break
case 1951551059:e.Q=!0
break
case 1665684045:if(e.c!==32){e.b.J()
s=e.a
if((s.a.a&30)===0)s.Y(B.q)
return}break
case 1934772034:if(e.c!==1){e.b.J()
s=e.a
if((s.a.a&30)===0)s.Y(B.q)
return}break
case 1883789683:if(e.c!==9){e.b.J()
s=e.a
if((s.a.a&30)===0)s.Y(B.q)
return}break
case 1732332865:if(e.c!==4){e.b.J()
s=e.a
if((s.a.a&30)===0)s.Y(B.q)
return}break
case 1766015824:e.ch=B.G
e.cx=B.F
break
case 1229209940:e.b.J()
if(!e.z)e.a.Y(B.bR)
s=q.buffer
b=new DataView(s,0)
l=b.getUint32(0,!1)
k=b.getUint32(4,!1)
j=b.getUint8(8)
switch(b.getUint8(9)){case 0:i=e.Q?B.ae:B.ad
break
case 2:case 3:i=e.Q?B.B:B.p
break
case 4:i=B.ae
break
case 6:i=B.B
break
default:i=B.P}s=e.cx
if(s===B.r)s=e.cx=B.t
r=e.ch
if(r===B.u)r=e.ch=B.v
q=e.cy
m=e.a.a
if((m.a&30)!==0)A.a3(A.bS("Future already completed"))
m.ad(new A.cq("image/png",j,i,l,k,s,r,q,!1))
return}if(e.c===0)e.y=4
else e.y=3}break
case 3:m=s.gh(b)
h=e.c
g=e.x
o=Math.min(m-p,h-g)
switch(e.e){case 1229472850:m=g+o
e.x=m
B.j.a5(q,g,m,b,p)
break
case 1665684045:case 1732332865:case 1883789683:m=g+o
e.x=m
B.j.a5(r,g,m,b,p)
break
case 1934772034:e.ch=B.v
e.cx=B.t
e.x=g+1
break
default:e.x=g+o}if(e.x===e.c){switch(e.e){case 1665684045:if(e.cx===B.r)e.dJ()
break
case 1732332865:if(e.ch===B.u)e.dK()
break
case 1883789683:m=r.buffer
f=new DataView(m,0)
if(f.getUint32(0,!1)!==f.getUint32(4,!1))e.cy=!0
break}e.y=4}p+=o
continue
case 4:if(++e.r===4){d.$0()
e.y=1}break}++p}},
dK(){var s=this
if(s.ch===B.v)return
switch(A.kI(s.dx.buffer,0,null).getUint32(0,!1)){case 45455:s.ch=B.v
break
case 1e5:s.ch=B.e9
break
default:s.ch=B.G}},
dJ(){var s,r=this
if(r.cx===B.t)return
s=A.kI(r.dx.buffer,0,null)
if(s.getUint32(0,!1)===31270&&s.getUint32(4,!1)===32900&&s.getUint32(8,!1)===64e3&&s.getUint32(12,!1)===33e3&&s.getUint32(16,!1)===3e4&&s.getUint32(20,!1)===6e4&&s.getUint32(24,!1)===15e3&&s.getUint32(28,!1)===6000)r.cx=B.t
else r.cx=B.F}}
A.kQ.prototype={
$0(){var s=this.a
s.r=s.x=s.f=s.e=s.d=s.c=0},
$S:1}
A.mp.prototype={
w(a,b){var s,r,q,p,o,n,m,l=this,k=J.a9(b),j=l.d,i=l.c
k=j+Math.min(k,30-j)
l.d=k
B.j.dn(i,j,k,b)
k=l.d
if(k>=25)k=k<30&&i[15]!==76
else k=!0
if(k)return
l.b.J()
s=A.kI(i.buffer,0,null)
if(s.getUint32(0,!1)!==1380533830||s.getUint32(8,!1)!==1464156752){l.cl(B.ai)
return}switch(s.getUint32(12,!1)){case 1448097824:r=s.getUint16(26,!0)&16383
q=s.getUint16(28,!0)&16383
p=B.p
o=!1
n=!1
break
case 1448097868:k=i[21]
j=i[22]
r=1+((k|(j&63)<<8)>>>0)
k=i[23]
i=i[24]
q=1+((j>>>6|k<<2|(i&15)<<10)>>>0)
p=(i&16)===16?B.B:B.p
o=!1
n=!1
break
case 1448097880:m=i[20]
n=(m&2)===2
o=(m&32)===32
p=(m&16)===16?B.B:B.p
r=((i[24]|i[25]<<8|i[26]<<16)>>>0)+1
q=((i[27]|i[28]<<8|i[29]<<16)>>>0)+1
break
default:l.cl(B.ai)
return}k=o?B.G:B.v
j=o?B.F:B.t
l.a.ai(0,new A.cq("image/webp",8,p,r,q,j,k,!1,n))}}
A.ec.prototype={$iao:1}
A.eb.prototype={$iao:1}
A.aO.prototype={
k(a){return this.a},
$iao:1}
A.dp.prototype={
k(a){return"_Storage."+this.b}}
A.fJ.prototype={
bf(){var s,r=this,q=t.X,p=t._,o=A.ai(q,p)
o.m(0,"pointer",r.a)
s=r.b
if(s!=null)o.m(0,"mimeType",s)
s=r.c
if(s!=null)o.m(0,"storage",B.cn[s.a])
s=r.e
if(s!=null)o.m(0,"uri",s)
s=r.d
if(s!=null)o.m(0,"byteLength",s)
s=r.f
if(s!=null){q=A.ai(q,p)
q.m(0,"width",s.d)
q.m(0,"height",s.e)
p=s.c
if(p!==B.P)q.m(0,"format",B.d0[p.a])
p=s.f
if(p!==B.r)q.m(0,"primaries",B.cV[p.a])
p=s.r
if(p!==B.u)q.m(0,"transfer",B.cU[p.a])
p=s.b
if(p>0)q.m(0,"bits",p)
o.m(0,"image",q)}return o}}
A.kV.prototype={
aO(a){var s=!0
return this.ev(0)},
ev(a){var s=0,r=A.hA(t.H),q,p=2,o,n=[],m=this,l,k,j
var $async$aO=A.hC(function(b,c){if(b===1){o=c
s=p}while(true)switch(s){case 0:k=!0
p=4
s=7
return A.dr(m.aX(),$async$aO)
case 7:s=8
return A.dr(m.aY(),$async$aO)
case 8:if(k)A.yM(m.a,m.b)
m.a.eQ(m.b)
p=2
s=6
break
case 4:p=3
j=o
if(A.X(j) instanceof A.cr){s=1
break}else throw j
s=6
break
case 3:s=2
break
case 6:case 1:return A.hw(q,r)
case 2:return A.hv(o,r)}})
return A.hx($async$aO,r)},
aX(){var s=0,r=A.hA(t.H),q=1,p,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4
var $async$aX=A.hC(function(a5,a6){if(a5===1){p=a6
s=q}while(true)switch(s){case 0:a2=n.b
a3=a2.c
B.d.sh(a3,0)
a3.push("buffers")
i=n.a.y,h=i.b,g=a2.dy,f=t.M,e=t.x,i=i.a,d=i.length,c=0
case 2:if(!(c<h)){s=4
break}b=c>=d
m=b?null:i[c]
if(m==null){s=3
break}a3.push(B.c.k(c))
a=new A.fJ(a2.R())
a.b="application/gltf-buffer"
l=new A.kW(n,a,c)
k=null
q=6
s=9
return A.dr(l.$1(m),$async$aX)
case 9:k=a6
q=1
s=8
break
case 6:q=5
a4=p
b=A.X(a4)
if(e.b(b)){j=b
a2.l($.oc(),A.a([j],f),"uri")}else throw a4
s=8
break
case 5:s=1
break
case 8:if(k!=null){a.d=J.a9(k)
if(J.a9(k)<m.y)a2.F($.ry(),A.a([J.a9(k),m.y],f))
else{if(a2.id&&c===0&&!m.z){b=m.y
a1=b+(-b&3)
if(J.a9(k)>a1)a2.F($.rz(),A.a([J.a9(k)-a1],f))}b=m
if(b.Q==null)b.Q=k}}g.push(a.bf())
a3.pop()
case 3:++c
s=2
break
case 4:return A.hw(null,r)
case 1:return A.hv(p,r)}})
return A.hx($async$aX,r)},
aY(){var s=0,r=A.hA(t.H),q=1,p,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8
var $async$aY=A.hC(function(b0,b1){if(b0===1){p=b1
s=q}while(true)switch(s){case 0:a6=n.b
a7=a6.c
B.d.sh(a7,0)
a7.push("images")
f=n.a.ch,e=f.b,d=a6.dy,c=t.M,b=t.x,a=a6.k1,f=f.a,a0=f.length,a1=0
case 2:if(!(a1<e)){s=4
break}a2=a1>=a0
m=a2?null:f[a1]
if(m==null){s=3
break}a7.push(B.c.k(a1))
a3=new A.fJ(a6.R())
l=new A.kX(n,a3)
k=null
try{k=l.$1(m)}catch(a9){a2=A.X(a9)
if(b.b(a2)){j=a2
a6.l($.oc(),A.a([j],c),"uri")}else throw a9}i=null
s=k!=null?5:6
break
case 5:q=8
s=11
return A.dr(A.vg(k),$async$aY)
case 11:i=b1
a2=B.d.I(a,i.a)
if(!a2)a6.F($.rD(),A.a([i.a],c))
q=1
s=10
break
case 8:q=7
a8=p
a2=A.X(a8)
if(a2 instanceof A.ec)a6.O($.rG())
else if(a2 instanceof A.eb)a6.O($.rF())
else if(a2 instanceof A.aO){h=a2
a6.F($.rA(),A.a([h],c))}else if(b.b(a2)){g=a2
a6.l($.oc(),A.a([g],c),"uri")}else throw a8
s=10
break
case 7:s=1
break
case 10:if(i!=null){a3.b=i.a
if(m.y!=null&&m.y!==i.a){a2=$.rC()
a5=A.a([i.a,m.y],c)
a6.l(a2,a5,a3.c===B.aM?"bufferView":"uri")}a2=i.d
if(a2!==0&&(a2&a2-1)>>>0===0){a2=i.e
a2=!(a2!==0&&(a2&a2-1)>>>0===0)}else a2=!0
if(a2)a6.F($.rE(),A.a([i.d,i.e],c))
a2=i
if(a2.f===B.F||a2.r===B.G||i.y||i.x)a6.O($.rB())
m.cx=i
a3.f=i}case 6:d.push(a3.bf())
a7.pop()
case 3:++a1
s=2
break
case 4:return A.hw(null,r)
case 1:return A.hv(p,r)}})
return A.hx($async$aY,r)}}
A.kW.prototype={
$1(a){var s,r,q,p=this
if(a.y===-1)return null
s=a.x
if(s!=null){r=p.b
r.c=B.aN
r.e=s.k(0)
return p.a.c.$1(s)}else{s=a.Q
if(s!=null){p.b.c=B.aL
return s}else{s=p.a
r=s.b
if(r.id&&p.c===0&&!a.z){p.b.c=B.eb
q=s.c.$0()
if(q==null)r.O($.t7())
return q}}}return null},
$S:69}
A.kX.prototype={
$1(a){var s,r=this,q=a.a
if(q.gv(q)){q=a.z
if(q!=null){s=r.b
s.c=B.aN
s.e=q.k(0)
return r.a.d.$1(q)}else{q=a.Q
if(q!=null){r.b.c=B.aL
return A.q8(q,t.w)}else if(a.ch!=null){r.b.c=B.aM
a.eO()
q=a.Q
if(q!=null)return A.q8(q,t.w)}}}return null},
$S:70}
A.o8.prototype={
$2(a,b){var s,r,q,p,o,n,m,l,k=A.nC(b)
if((k==null?null:k.dx)!=null){k=this.a
s=k.c
B.d.sh(s,0)
s.push("accessors")
s.push(B.c.k(a))
r=b.dx.ges()
if(r!=null)for(s=r.length,q=b.Q,p=t.M,o=0,n=-1,m=0;m<s;++m,n=l){l=r[m]
if(n!==-1&&l<=n)k.l($.rv(),A.a([o,l,n],p),"sparse")
if(l>=q)k.l($.ru(),A.a([o,l,q],p),"sparse");++o}}},
$S:71}
A.o9.prototype={
$1(a){return a.cx===0},
$S:7}
A.oa.prototype={
$2(a,b){var s,r,q,p,o=this,n=null,m=b.fr,l=b.cx,k=A.W(l,n,!1,t.bF),j=A.W(l,n,!1,t.ga),i=b.dx,h=0
while(!0){if(!(h<l)){s=!1
break}r=A.nC(i.j(0,"JOINTS_"+h))
q=A.nC(i.j(0,"WEIGHTS_"+h))
if((r==null?n:r.Q)===m)p=(q==null?n:q.Q)!==m
else p=!0
if(p){s=!0
break}p=r.ab()
k[h]=new A.aL(p.a(),A.D(p).i("aL<1>"))
p=q.bh()
j[h]=new A.aL(p.a(),A.D(p).i("aL<1>"));++h}if(s)return
l=o.b
i=l.c
i.push(B.c.k(a))
i.push("attributes")
p=o.c
B.d.H(p,k)
B.d.H(p,j)
l=l.R()
p=o.a
o.d.push(new A.fi(k,j,p.b-1,p.a,l,A.aQ(t.e)))
i.pop()
i.pop()},
$S:23}
A.nG.prototype={
$1(a){return a.gt()==null},
$S:72}
A.fi.prototype={
eg(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=s.length,q=e.b,p=e.c,o=e.e,n=t.M,m=e.Q,l=e.d,k=0;k<r;++k){j=s[k].gt()
if(j==null){e.x=!0
return}if(j>p){i=$.rr()
h=o+"/JOINTS_"+k
a.l(i,A.a([e.f,e.r,j,p,l],n),h)
continue}g=q[k].gt()
if(g!==0){if(!m.w(0,j)){i=$.rq()
h=o+"/JOINTS_"+k
a.l(i,A.a([e.f,e.r,j],n),h)
f=!1}else f=!0
if(g<0){i=$.rw()
h=o+"/WEIGHTS_"+k
a.l(i,A.a([e.f,e.r,g],n),h)}else if(f){i=e.y
h=$.pn()
h[0]=i+g
e.y=h[0]
e.z+=2e-7}}else if(j!==0){i=$.rs()
h=o+"/JOINTS_"+k
a.l(i,A.a([e.f,e.r,j],n),h)}}if(4===++e.r){if(Math.abs(e.y-1)>e.z)for(k=0;k<r;++k){s=$.rx()
q=o+"/WEIGHTS_"+k
p=e.f
a.l(s,A.a([p-3,p,e.y],n),q)}m.at(0)
e.y=e.z=e.r=0}++e.f}}
A.dd.prototype={
k(a){return"Severity."+this.b}}
A.jn.prototype={}
A.i7.prototype={}
A.iw.prototype={
$1(a){return"Actual data byte length ("+A.b(a[0])+") is less than the declared buffer byte length ("+A.b(a[1])+")."},
$S:0}
A.ix.prototype={
$1(a){return"GLB-stored BIN chunk contains "+A.b(a[0])+" extra padding byte(s)."},
$S:0}
A.ip.prototype={
$1(a){return"Declared minimum value for this component ("+A.b(a[0])+") does not match actual minimum ("+A.b(a[1])+")."},
$S:0}
A.io.prototype={
$1(a){return"Declared maximum value for this component ("+A.b(a[0])+") does not match actual maximum ("+A.b(a[1])+")."},
$S:0}
A.ic.prototype={
$1(a){return"Accessor contains "+A.b(a[0])+" element(s) less than declared minimum value "+A.b(a[1])+"."},
$S:0}
A.ib.prototype={
$1(a){return"Accessor contains "+A.b(a[0])+" element(s) greater than declared maximum value "+A.b(a[1])+"."},
$S:0}
A.it.prototype={
$1(a){return"Vector3 at accessor indices "+A.b(a[0])+".."+A.b(a[1])+" is not of unit length: "+A.b(a[2])+"."},
$S:0}
A.ij.prototype={
$1(a){return"Vector3 with sign at accessor indices "+A.b(a[0])+".."+A.b(a[1])+" has invalid w component: "+A.b(a[2])+". Must be 1.0 or -1.0."},
$S:0}
A.ia.prototype={
$1(a){return"Animation sampler output accessor element at indices "+A.b(a[0])+".."+A.b(a[1])+" is not of unit length: "+A.b(a[2])+"."},
$S:0}
A.iq.prototype={
$1(a){return"Accessor element at index "+A.b(a[0])+" is not clamped to 0..1 range: "+A.b(a[1])+"."},
$S:0}
A.ih.prototype={
$1(a){return"Accessor element at index "+A.b(a[0])+" is "+A.b(a[1])+"."},
$S:0}
A.id.prototype={
$1(a){return"Indices accessor element at index "+A.b(a[0])+" has value "+A.b(a[1])+" that is greater than the maximum vertex index available ("+A.b(a[2])+")."},
$S:0}
A.ig.prototype={
$1(a){return"Indices accessor contains "+A.b(a[0])+" degenerate triangles (out of "+A.b(a[1])+")."},
$S:0}
A.ie.prototype={
$1(a){return"Indices accessor contains primitive restart value ("+A.b(a[0])+") at index "+A.b(a[1])+"."},
$S:0}
A.i8.prototype={
$1(a){return u.m+A.b(a[0])+" is negative: "+A.b(a[1])+"."},
$S:0}
A.i9.prototype={
$1(a){return u.m+A.b(a[0])+" is less than or equal to previous: "+A.b(a[1])+" <= "+A.b(a[2])+"."},
$S:0}
A.is.prototype={
$1(a){return u.d+A.b(a[0])+" is less than or equal to previous: "+A.b(a[1])+" <= "+A.b(a[2])+"."},
$S:0}
A.ir.prototype={
$1(a){return u.d+A.b(a[0])+" is greater than or equal to the number of accessor elements: "+A.b(a[1])+" >= "+A.b(a[2])+"."},
$S:0}
A.ii.prototype={
$1(a){return"Matrix element at index "+A.b(a[0])+" (component index "+A.b(a[1])+") contains invalid value: "+A.b(a[2])+"."},
$S:0}
A.iz.prototype={
$1(a){return"Image data is invalid. "+A.b(a[0])},
$S:0}
A.iB.prototype={
$1(a){return"Recognized image format "+("'"+A.b(a[0])+"'")+" does not match declared image format "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.iE.prototype={
$1(a){return"Unexpected end of image stream."},
$S:0}
A.iF.prototype={
$1(a){return"Image format not recognized."},
$S:0}
A.iC.prototype={
$1(a){return"'"+A.b(a[0])+"' MIME type requires an extension."},
$S:0}
A.iD.prototype={
$1(a){return"Image has non-power-of-two dimensions: "+A.b(a[0])+"x"+A.b(a[1])+"."},
$S:0}
A.iA.prototype={
$1(a){return"Image contains unsupported features like non-default colorspace information, non-square pixels, or animation."},
$S:0}
A.iG.prototype={
$1(a){return"URI is used in GLB container."},
$S:0}
A.iy.prototype={
$1(a){return"Data URI is used in GLB container."},
$S:0}
A.il.prototype={
$1(a){return"Joints accessor element at index "+A.b(a[0])+" (component index "+A.b(a[1])+") has value "+A.b(a[2])+" that is greater than the maximum joint index ("+A.b(a[3])+") set by skin "+A.b(a[4])+"."},
$S:0}
A.ik.prototype={
$1(a){return"Joints accessor element at index "+A.b(a[0])+" (component index "+A.b(a[1])+") has value "+A.b(a[2])+" that is already in use for the vertex."},
$S:0}
A.iu.prototype={
$1(a){return"Weights accessor element at index "+A.b(a[0])+" (component index "+A.b(a[1])+") has negative value "+A.b(a[2])+"."},
$S:0}
A.iv.prototype={
$1(a){return"Weights accessor elements (at indices "+A.b(a[0])+".."+A.b(a[1])+") have non-normalized sum: "+A.b(a[2])+"."},
$S:0}
A.im.prototype={
$1(a){return"Joints accessor element at index "+A.b(a[0])+" (component index "+A.b(a[1])+") is used with zero weight but has non-zero value ("+A.b(a[2])+")."},
$S:0}
A.jl.prototype={}
A.jm.prototype={
$1(a){return J.aZ(a[0])},
$S:0}
A.kZ.prototype={}
A.l0.prototype={
$1(a){return"Invalid array length "+A.b(a[0])+". Valid lengths are: "+J.bc(a[1],A.qW(),t.X).k(0)+"."},
$S:0}
A.l1.prototype={
$1(a){var s=a[0]
return"Type mismatch. Array element "+A.b(typeof s=="string"?"'"+s+"'":J.aZ(s))+" is not a "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.l_.prototype={
$1(a){return"Duplicate element."},
$S:0}
A.l3.prototype={
$1(a){return"Index must be a non-negative integer."},
$S:0}
A.l4.prototype={
$1(a){return"Invalid JSON data. Parser output: "+A.b(a[0])},
$S:0}
A.l5.prototype={
$1(a){return"Invalid URI "+("'"+A.b(a[0])+"'")+". Parser output:\n"+A.b(a[1])},
$S:0}
A.l2.prototype={
$1(a){return"Entity cannot be empty."},
$S:0}
A.l6.prototype={
$1(a){a.toString
return"Exactly one of "+new A.a8(a,A.dx(),A.a2(a).i("a8<1,d*>")).k(0)+" properties must be defined."},
$S:0}
A.l7.prototype={
$1(a){return"Value "+("'"+A.b(a[0])+"'")+" does not match regexp pattern "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.l8.prototype={
$1(a){var s=a[0]
return"Type mismatch. Property value "+A.b(typeof s=="string"?"'"+s+"'":J.aZ(s))+" is not a "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.ld.prototype={
$1(a){var s=a[0]
return"Invalid value "+A.b(typeof s=="string"?"'"+s+"'":J.aZ(s))+". Valid values are "+J.bc(a[1],A.qW(),t.X).k(0)+"."},
$S:0}
A.le.prototype={
$1(a){return"Value "+A.b(a[0])+" is out of range."},
$S:0}
A.lc.prototype={
$1(a){return"Value "+A.b(a[0])+" is not a multiple of "+A.b(a[1])+"."},
$S:0}
A.l9.prototype={
$1(a){return"Property "+("'"+A.b(a[0])+"'")+" must be defined."},
$S:0}
A.la.prototype={
$1(a){return"Unexpected property."},
$S:0}
A.lb.prototype={
$1(a){return"Dependency failed. "+("'"+A.b(a[0])+"'")+" must be defined."},
$S:0}
A.lf.prototype={}
A.lZ.prototype={
$1(a){return"Unknown glTF major asset version: "+A.b(a[0])+"."},
$S:0}
A.m_.prototype={
$1(a){return"Unknown glTF minor asset version: "+A.b(a[0])+"."},
$S:0}
A.lK.prototype={
$1(a){return"Asset minVersion "+("'"+A.b(a[0])+"'")+" is greater than version "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.lu.prototype={
$1(a){return"Invalid value "+A.b(a[0])+" for GL type "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.lh.prototype={
$1(a){return"Only (u)byte and (u)short accessors can be normalized."},
$S:0}
A.li.prototype={
$1(a){return"Offset "+A.b(a[0])+" is not a multiple of componentType length "+A.b(a[1])+"."},
$S:0}
A.lg.prototype={
$1(a){return"Matrix accessors must be aligned to 4-byte boundaries."},
$S:0}
A.lj.prototype={
$1(a){return"Sparse accessor overrides more elements ("+A.b(a[0])+") than the base accessor contains ("+A.b(a[1])+")."},
$S:0}
A.lk.prototype={
$1(a){return"Animated TRS properties will not affect a skinned mesh."},
$S:0}
A.ll.prototype={
$1(a){return"Data URI media type must be 'application/octet-stream' or 'application/gltf-buffer'. Found "+("'"+A.b(a[0])+"'")+" instead."},
$S:0}
A.ln.prototype={
$1(a){return"Buffer view's byteStride ("+A.b(a[0])+") is greater than byteLength ("+A.b(a[1])+")."},
$S:0}
A.lm.prototype={
$1(a){return"Only buffer views with raw vertex data can have byteStride."},
$S:0}
A.lo.prototype={
$1(a){return"xmag and ymag should not be negative."},
$S:0}
A.lp.prototype={
$1(a){return"xmag and ymag must not be zero."},
$S:0}
A.lq.prototype={
$1(a){return"yfov should be less than Pi."},
$S:0}
A.lr.prototype={
$1(a){return"zfar must be greater than znear."},
$S:0}
A.lC.prototype={
$1(a){return"Alpha cutoff is supported only for 'MASK' alpha mode."},
$S:0}
A.lF.prototype={
$1(a){return"Invalid attribute name."},
$S:0}
A.lJ.prototype={
$1(a){return"All primitives must have the same number of morph targets."},
$S:0}
A.lH.prototype={
$1(a){return"No POSITION attribute found."},
$S:0}
A.lE.prototype={
$1(a){return"Indices for indexed attribute semantic "+("'"+A.b(a[0])+"'")+" must start with 0 and be continuous. Total expected indices: "+A.b(a[1])+", total provided indices: "+A.b(a[2])+"."},
$S:0}
A.lI.prototype={
$1(a){return"TANGENT attribute without NORMAL found."},
$S:0}
A.lG.prototype={
$1(a){return"Number of JOINTS attribute semantics ("+A.b(a[0])+") does not match the number of WEIGHTS ("+A.b(a[1])+")."},
$S:0}
A.lD.prototype={
$1(a){return"The length of weights array ("+A.b(a[0])+u.p+A.b(a[1])+")."},
$S:0}
A.lO.prototype={
$1(a){return"A node can have either a matrix or any combination of translation/rotation/scale (TRS) properties."},
$S:0}
A.lM.prototype={
$1(a){return"Do not specify default transform matrix."},
$S:0}
A.lP.prototype={
$1(a){return"Matrix must be decomposable to TRS."},
$S:0}
A.lW.prototype={
$1(a){return"Rotation quaternion must be normalized."},
$S:0}
A.m1.prototype={
$1(a){return"Unused extension "+("'"+A.b(a[0])+"'")+" cannot be required."},
$S:0}
A.lV.prototype={
$1(a){return"Extension "+("'"+A.b(a[0])+"'")+" cannot be optional."},
$S:0}
A.m0.prototype={
$1(a){return"Extension uses unreserved extension prefix "+("'"+A.b(a[0])+"'")+"."},
$S:0}
A.lt.prototype={
$1(a){return"Extension name has invalid format."},
$S:0}
A.lN.prototype={
$1(a){return"Empty node encountered."},
$S:0}
A.lS.prototype={
$1(a){return"Node with a skinned mesh is not root. Parent transforms will not affect a skinned mesh."},
$S:0}
A.lR.prototype={
$1(a){return"Local transforms will not affect a skinned mesh."},
$S:0}
A.lQ.prototype={
$1(a){return"A node with a skinned mesh is used in a scene that does not contain joint nodes."},
$S:0}
A.lX.prototype={
$1(a){return"Joints do not have a common root."},
$S:0}
A.lY.prototype={
$1(a){return"Skeleton node is not a common root."},
$S:0}
A.lU.prototype={
$1(a){return"Non-relative URI found: "+("'"+A.b(a[0])+"'")+"."},
$S:0}
A.lL.prototype={
$1(a){return"This extension may be incompatible with other extensions for the object."},
$S:0}
A.lT.prototype={
$1(a){return"Prefer JSON Objects for extras."},
$S:0}
A.ls.prototype={
$1(a){return"This property should not be defined as it will not be used."},
$S:0}
A.lv.prototype={
$1(a){return"outerConeAngle ("+A.b(a[1])+") is less than or equal to innerConeAngle ("+A.b(a[0])+")."},
$S:0}
A.lw.prototype={
$1(a){return"Emissive strength has no effect when the emissive factor is zero or undefined."},
$S:0}
A.lB.prototype={
$1(a){return"The volume extension needs to be combined with an extension that allows light to transmit through the surface."},
$S:0}
A.lA.prototype={
$1(a){return"The volume extension should not be used with double-sided materials."},
$S:0}
A.ly.prototype={
$1(a){return"Thickness minimum has no effect when a thickness texture is not defined."},
$S:0}
A.lx.prototype={
$1(a){return"Thickness maximum must be greater than or equal to the thickness minimum."},
$S:0}
A.lz.prototype={
$1(a){return"Thickness texture has no effect when the thickness minimum is equal to the thickness maximum."},
$S:0}
A.jF.prototype={}
A.jI.prototype={
$1(a){return"Accessor's total byteOffset "+A.b(a[0])+" isn't a multiple of componentType length "+A.b(a[1])+"."},
$S:0}
A.jG.prototype={
$1(a){return"Referenced bufferView's byteStride value "+A.b(a[0])+" is less than accessor element's length "+A.b(a[1])+"."},
$S:0}
A.jH.prototype={
$1(a){return"Accessor (offset: "+A.b(a[0])+", length: "+A.b(a[1])+") does not fit referenced bufferView ["+A.b(a[2])+"] length "+A.b(a[3])+"."},
$S:0}
A.jJ.prototype={
$1(a){return"Override of previously set accessor usage. Initial: "+("'"+A.b(a[0])+"'")+", new: "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.jM.prototype={
$1(a){return"Animation channel has the same target as channel "+A.b(a[0])+"."},
$S:0}
A.jK.prototype={
$1(a){return"Animation channel cannot target TRS properties of a node with defined matrix."},
$S:0}
A.jL.prototype={
$1(a){return"Animation channel cannot target WEIGHTS when mesh does not have morph targets."},
$S:0}
A.jQ.prototype={
$1(a){return"accessor.min and accessor.max must be defined for animation input accessor."},
$S:0}
A.jO.prototype={
$1(a){return"Invalid Animation sampler input accessor format "+("'"+A.b(a[0])+"'")+". Must be one of "+J.bc(a[1],A.dx(),t.X).k(0)+"."},
$S:0}
A.jS.prototype={
$1(a){return"Invalid animation sampler output accessor format "+("'"+A.b(a[0])+"'")+" for path "+("'"+A.b(a[2])+"'")+". Must be one of "+J.bc(a[1],A.dx(),t.X).k(0)+"."},
$S:0}
A.jP.prototype={
$1(a){return"Animation sampler output accessor with "+("'"+A.b(a[0])+"'")+" interpolation must have at least "+A.b(a[1])+" elements. Got "+A.b(a[2])+"."},
$S:0}
A.jR.prototype={
$1(a){return"Animation sampler output accessor of count "+A.b(a[0])+" expected. Found "+A.b(a[1])+"."},
$S:0}
A.jN.prototype={
$1(a){return"bufferView.byteStride must not be defined for buffer views used by animation sampler accessors."},
$S:0}
A.jT.prototype={
$1(a){return"Buffer refers to an unresolved GLB binary chunk."},
$S:0}
A.jW.prototype={
$1(a){return"BufferView does not fit buffer ("+A.b(a[0])+") byteLength ("+A.b(a[1])+")."},
$S:0}
A.jV.prototype={
$1(a){return"Override of previously set bufferView target or usage. Initial: "+("'"+A.b(a[0])+"'")+", new: "+("'"+A.b(a[1])+"'")+"."},
$S:0}
A.jU.prototype={
$1(a){return"bufferView.target should be set for vertex or index data."},
$S:0}
A.jX.prototype={
$1(a){return"bufferView.byteStride must not be defined for buffer views containing image data."},
$S:0}
A.jY.prototype={
$1(a){return"IBM accessor must have at least "+A.b(a[0])+" elements. Found "+A.b(a[1])+"."},
$S:0}
A.k1.prototype={
$1(a){return"Invalid accessor format "+("'"+A.b(a[0])+"'")+" for this attribute semantic. Must be one of "+J.bc(a[1],A.dx(),t.X).k(0)+"."},
$S:0}
A.k2.prototype={
$1(a){return"Mesh attributes cannot use UNSIGNED_INT component type."},
$S:0}
A.k8.prototype={
$1(a){return"accessor.min and accessor.max must be defined for POSITION attribute accessor."},
$S:0}
A.k0.prototype={
$1(a){return"bufferView.byteStride must be defined when two or more accessors use the same buffer view."},
$S:0}
A.k_.prototype={
$1(a){return"Vertex attribute data must be aligned to 4-byte boundaries."},
$S:0}
A.k5.prototype={
$1(a){return"bufferView.byteStride must not be defined for indices accessor."},
$S:0}
A.k4.prototype={
$1(a){return"Invalid indices accessor format "+("'"+A.b(a[0])+"'")+". Must be one of "+J.bc(a[1],A.dx(),t.X).k(0)+". "},
$S:0}
A.k3.prototype={
$1(a){return"Number of vertices or indices ("+A.b(a[0])+") is not compatible with used drawing mode ("+("'"+A.b(a[1])+"'")+")."},
$S:0}
A.k9.prototype={
$1(a){return"Material is incompatible with mesh primitive: Texture binding "+("'"+A.b(a[0])+"'")+" needs 'TEXCOORD_"+A.b(a[1])+"' attribute."},
$S:0}
A.ka.prototype={
$1(a){return"All accessors of the same primitive must have the same count."},
$S:0}
A.k7.prototype={
$1(a){return"The mesh primitive does not define this attribute semantic."},
$S:0}
A.k6.prototype={
$1(a){return"Base accessor has different count."},
$S:0}
A.kb.prototype={
$1(a){return"Node is a part of a node loop."},
$S:0}
A.kc.prototype={
$1(a){return"Value overrides parent of node "+A.b(a[0])+"."},
$S:0}
A.kf.prototype={
$1(a){var s="The length of weights array ("+A.b(a[0])+u.p,r=a[1]
return s+A.b(r==null?0:r)+")."},
$S:0}
A.kd.prototype={
$1(a){return"Node has skin defined, but mesh has no joints data."},
$S:0}
A.ke.prototype={
$1(a){return"Node uses skinned mesh, but has no skin defined."},
$S:0}
A.kg.prototype={
$1(a){return"Node "+A.b(a[0])+" is not a root node."},
$S:0}
A.ki.prototype={
$1(a){return"Invalid IBM accessor format "+("'"+A.b(a[0])+"'")+". Must be one of "+J.bc(a[1],A.dx(),t.X).k(0)+". "},
$S:0}
A.kh.prototype={
$1(a){return"bufferView.byteStride must not be defined for buffer views used by inverse bind matrices accessors."},
$S:0}
A.kj.prototype={
$1(a){return"Invalid MIME type "+("'"+A.b(a[0])+"'")+" for the texture source. Valid MIME types are "+J.bc(a[1],A.dx(),t.X).k(0)+"."},
$S:0}
A.kk.prototype={
$1(a){return"Extension is not declared in extensionsUsed."},
$S:0}
A.kl.prototype={
$1(a){return"Unexpected location for this extension."},
$S:0}
A.km.prototype={
$1(a){return"Unresolved reference: "+A.b(a[0])+"."},
$S:0}
A.kn.prototype={
$1(a){return"Cannot validate an extension as it is not supported by the validator: "+("'"+A.b(a[0])+"'")+"."},
$S:0}
A.kq.prototype={
$1(a){return"This object may be unused."},
$S:0}
A.kp.prototype={
$1(a){return"The static morph target weights are always overridden."},
$S:0}
A.ko.prototype={
$1(a){return"Tangents are not used because the material has no normal texture."},
$S:0}
A.jZ.prototype={
$1(a){return"This variant is used more than once for this mesh primitive."},
$S:0}
A.iL.prototype={}
A.iS.prototype={
$1(a){return"Invalid GLB magic value ("+A.b(a[0])+")."},
$S:0}
A.iT.prototype={
$1(a){return"Invalid GLB version value "+A.b(a[0])+"."},
$S:0}
A.iV.prototype={
$1(a){return"Declared GLB length ("+A.b(a[0])+") is too small."},
$S:0}
A.iM.prototype={
$1(a){return"Length of "+A.b(a[0])+" chunk is not aligned to 4-byte boundaries."},
$S:0}
A.iU.prototype={
$1(a){return"Declared length ("+A.b(a[0])+") does not match GLB length ("+A.b(a[1])+")."},
$S:0}
A.iN.prototype={
$1(a){return"Chunk ("+A.b(a[0])+") length ("+A.b(a[1])+") does not fit total GLB length."},
$S:0}
A.iQ.prototype={
$1(a){return"Chunk ("+A.b(a[0])+") cannot have zero length."},
$S:0}
A.iP.prototype={
$1(a){return"Empty BIN chunk should be omitted."},
$S:0}
A.iO.prototype={
$1(a){return"Chunk of type "+A.b(a[0])+" has already been used."},
$S:0}
A.iY.prototype={
$1(a){return"Unexpected end of chunk header."},
$S:0}
A.iX.prototype={
$1(a){return"Unexpected end of chunk data."},
$S:0}
A.iZ.prototype={
$1(a){return"Unexpected end of header."},
$S:0}
A.j_.prototype={
$1(a){return"First chunk must be of JSON type. Found "+A.b(a[0])+" instead."},
$S:0}
A.iW.prototype={
$1(a){return"BIN chunk must be the second chunk."},
$S:0}
A.j0.prototype={
$1(a){return"Unknown GLB chunk type: "+A.b(a[0])+"."},
$S:0}
A.iR.prototype={
$1(a){return"Extra data after the end of GLB stream."},
$S:0}
A.bJ.prototype={
gbb(a){var s=J.uL(this.a.c.$1(this.e))
return s},
gbl(){return this.a.a},
gC(a){return B.a.gC(this.k(0))},
N(a,b){if(b==null)return!1
return b instanceof A.bJ&&b.k(0)===this.k(0)},
k(a){var s=this,r=s.c
if(r!=null&&r.length!==0)return A.b(r)+": "+s.gbb(s)
r=s.d
if(r!=null)return"@"+A.b(r)+": "+s.gbb(s)
return s.gbb(s)}}
A.cm.prototype={
q(a,b){var s=this.d,r=this.e=a.ch.j(0,s)
if(s!==-1)if(r==null)b.l($.T(),A.a([s],t.M),"source")
else r.a$=!0},
bY(a,b){var s=this.e,r=s==null,q=r?null:s.y
if(q==null){s=r?null:s.cx
q=s==null?null:s.a}if(q!=null&&q!=="image/webp")b.l($.p9(),A.a([q,B.cW],t.M),"source")},
$icP:1}
A.bL.prototype={
q(a,b){var s,r,q=b.c
q.push("lights")
s=this.d
r=J.d7(q.slice(0),A.a2(q).c)
b.y.m(0,s,r)
s.a4(new A.jz(b,a))
q.pop()}}
A.jz.prototype={
$2(a,b){var s=this.a.c
s.push(B.c.k(a))
s.pop()},
$S:74}
A.bp.prototype={}
A.cu.prototype={}
A.cv.prototype={
q(a,b){var s,r,q=a.a.j(0,"KHR_lights_punctual")
if(q instanceof A.bL){s=this.d
r=this.e=q.d.j(0,s)
if(s!==-1)if(r==null)b.l($.T(),A.a([s],t.M),"light")
else r.a$=!0}else b.F($.d_(),A.a(["/extensions/KHR_lights_punctual"],t.M))}}
A.cw.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("clearcoatTexture")
r.q(a,b)
s.pop()}r=this.r
if(r!=null){s=b.c
s.push("clearcoatRoughnessTexture")
r.q(a,b)
s.pop()}r=this.x
if(r!=null){s=b.c
s.push("clearcoatNormalTexture")
r.q(a,b)
s.pop()}}}
A.cx.prototype={
q(a,b){var s,r,q=this.d
q=isNaN(q)||q===1
if(q)return
for(q=b.e,s=this;s!=null;){s=q.j(0,s)
if(s instanceof A.aE){r=s.ch
if(r!=null&&J.am(r[0],0)&&J.am(r[1],0)&&J.am(r[2],0))b.O($.tN())
break}}}}
A.cy.prototype={}
A.cz.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("iridescenceTexture")
r.q(a,b)
s.pop()}r=this.y
if(r!=null){s=b.c
s.push("iridescenceThicknessTexture")
r.q(a,b)
s.pop()}}}
A.cA.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("diffuseTexture")
r.q(a,b)
s.pop()}r=this.x
if(r!=null){s=b.c
s.push("specularGlossinessTexture")
r.q(a,b)
s.pop()}}}
A.cB.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("sheenColorTexture")
r.q(a,b)
s.pop()}r=this.r
if(r!=null){s=b.c
s.push("sheenRoughnessTexture")
r.q(a,b)
s.pop()}}}
A.cC.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("specularTexture")
r.q(a,b)
s.pop()}r=this.r
if(r!=null){s=b.c
s.push("specularColorTexture")
r.q(a,b)
s.pop()}}}
A.cD.prototype={
q(a,b){var s,r=this.e
if(r!=null){s=b.c
s.push("transmissionTexture")
r.q(a,b)
s.pop()}}}
A.cE.prototype={}
A.bM.prototype={
q(a,b){var s,r,q=b.c
q.push("variants")
s=this.d
r=J.d7(q.slice(0),A.a2(q).c)
b.y.m(0,s,r)
s.a4(new A.jA(b,a))
q.pop()}}
A.jA.prototype={
$2(a,b){var s=this.a.c
s.push(B.c.k(a))
s.pop()},
$S:75}
A.aP.prototype={}
A.cF.prototype={
q(a,b){var s=b.c
s.push("mappings")
this.d.a4(new A.jD(b,a,A.aQ(t.e)))
s.pop()}}
A.jD.prototype={
$2(a,b){var s=this.a,r=s.c
r.push(B.c.k(a))
b.cV(this.b,s,this.c)
r.pop()},
$S:76}
A.bq.prototype={
cV(a,b,c){var s,r,q,p=this,o=a.a.j(0,"KHR_materials_variants")
if(o instanceof A.bM){s=p.d
if(s!=null){r=b.c
r.push("variants")
A.pQ(s.gh(s),new A.jB(p,o,b,c),!1,t.q)
r.pop()}s=p.e
r=p.r=a.cx.j(0,s)
if(s!==-1)if(r==null)b.l($.T(),A.a([s],t.M),"material")
else{r.a$=!0
for(s=b.e,q=p;q!=null;){q=s.j(0,q)
if(q instanceof A.aJ){p.r.dy.K(0,new A.jC(q,b))
break}}}}else b.F($.d_(),A.a(["/extensions/KHR_materials_variants"],t.M))},
q(a,b){return this.cV(a,b,null)}}
A.jB.prototype={
$1(a){var s=this,r=s.a.d.j(0,a),q=s.b.d.j(0,r)
if(r!==-1){if(!s.d.w(0,r))s.c.X($.tc(),a)
if(q==null)s.c.an($.T(),A.a([r],t.M),a)
else q.a$=!0}return q},
$S:77}
A.jC.prototype={
$2(a,b){var s
if(b!==-1){s=this.a
if(b+1>s.db)this.b.l($.p8(),A.a([a,b],t.M),"material")
else s.id[b]=-1}},
$S:6}
A.cG.prototype={
q(a,b){var s,r,q=this.r
if(q!=null){s=b.c
s.push("thicknessTexture")
q.q(a,b)
s.pop()}for(q=b.e,r=this;r!=null;){r=q.j(0,r)
if(r instanceof A.aE){q=r.a
if(!q.B("KHR_materials_transmission")&&!q.gU(q).aF(0,new A.jE()))b.O($.tS())
if(r.db&&this.f>0)b.O($.tR())
break}}}}
A.jE.prototype={
$1(a){return t.h.b(a)},
$S:78}
A.cH.prototype={
q(a,b){var s,r
for(s=b.e,r=this;r!=null;){r=s.j(0,r)
if(r instanceof A.aE){r.dy.m(0,b.R(),this.r)
break}}}}
A.U.prototype={}
A.Z.prototype={}
A.cn.prototype={
gC(a){var s=J.d0(this.a),r=J.d0(this.b)
return A.qD(A.hy(A.hy(0,B.c.gC(s)),B.c.gC(r)))},
N(a,b){if(b==null)return!1
return b instanceof A.cn&&this.b==b.b&&this.a==b.a}}
A.cJ.prototype={}
A.fK.prototype={}
A.fc.prototype={
bU(){var s=this,r=s.d=s.c.b9(new A.j3(s),s.ge_(),s.gcp()),q=s.dy
q.e=r.geA(r)
q.f=r.geC()
q.r=new A.j4(s)
return s.e.a},
aB(){this.d.J()
var s=this.e
if((s.a.a&30)===0)s.ai(0,new A.aI("model/gltf-binary",null,this.fx))},
dZ(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b="model/gltf-binary",a="0"
c.d.bd(0)
for(s=J.S(a0),r=t.f,q=t.j,p=t.M,o=c.a,n=0,m=0;n!==s.gh(a0);)switch(c.r){case 0:l=s.gh(a0)
k=c.x
m=Math.min(l-n,12-k)
l=k+m
c.x=l
B.j.a5(o,k,l,a0,n)
n+=m
c.y=m
if(c.x!==12)break
j=c.b.getUint32(0,!0)
if(j!==1179937895){c.f.a3($.rN(),A.a([j],p),0)
c.d.J()
s=c.e.a
if((s.a&30)===0){r=c.fx
s.ad(new A.aI(b,null,r))}return}i=c.b.getUint32(4,!0)
if(i!==2){c.f.a3($.rO(),A.a([i],p),4)
c.d.J()
s=c.e.a
if((s.a&30)===0){r=c.fx
s.ad(new A.aI(b,null,r))}return}l=c.z=c.b.getUint32(8,!0)
if(l<=c.y)c.f.a3($.rQ(),A.a([l],p),8)
c.r=1
c.x=0
break
case 1:l=c.y
if(l===c.z){c.f.aE($.rM(),l)
c.d.J()
c.co()
return}l=s.gh(a0)
k=c.x
m=Math.min(l-n,8-k)
l=k+m
c.x=l
B.j.a5(o,k,l,a0,n)
n+=m
c.y+=m
if(c.x!==8)break
c.ch=c.b.getUint32(0,!0)
l=c.b.getUint32(4,!0)
c.cx=l
if((c.ch&3)!==0){k=c.f
h=$.rH()
g=c.y
k.a3(h,A.a(["0x"+B.a.ap(B.c.aq(l,16),8,a)],p),g-8)}if(c.y+c.ch>c.z)c.f.a3($.rI(),A.a(["0x"+B.a.ap(B.c.aq(c.cx,16),8,a),c.ch],p),c.y-8)
if(c.Q===0&&c.cx!==1313821514)c.f.a3($.rV(),A.a(["0x"+B.a.ap(B.c.aq(c.cx,16),8,a)],p),c.y-8)
l=c.cx
if(l===5130562&&c.Q>1&&!c.fr)c.f.a3($.rR(),A.a(["0x"+B.a.ap(B.c.aq(l,16),8,a)],p),c.y-8)
f=new A.j1(c)
l=c.cx
switch(l){case 1313821514:if(c.ch===0){k=c.f
h=$.rL()
g=c.y
k.a3(h,A.a(["0x"+B.a.ap(B.c.aq(l,16),8,a)],p),g-8)}f.$1$seen(c.cy)
c.cy=!0
break
case 5130562:if(c.ch===0)c.f.aE($.rK(),c.y-8)
f.$1$seen(c.fr)
c.fr=!0
break
default:c.f.a3($.rW(),A.a(["0x"+B.a.ap(B.c.aq(l,16),8,a)],p),c.y-8)
c.r=4294967295}++c.Q
c.x=0
break
case 1313821514:m=Math.min(s.gh(a0)-n,c.ch-c.x)
if(c.db==null){l=c.dy
k=c.f
l=new A.dK(new A.b9(l,A.D(l).i("b9<1>")),new A.by(new A.I($.F,r),q))
l.e=k
c.db=l
c.dx=l.bU()}l=c.dy
e=n+m
k=s.a2(a0,n,e)
h=l.b
if(h>=4)A.a3(l.bn())
if((h&1)!==0)l.b2(k)
else if((h&3)===0){l=l.bw()
k=new A.dj(k)
d=l.c
if(d==null)l.b=l.c=k
else{d.saw(k)
l.c=k}}l=c.x+=m
c.y+=m
if(l===c.ch){c.dy.ah(0)
c.r=1
c.x=0}n=e
break
case 5130562:l=s.gh(a0)
k=c.ch
h=c.x
m=Math.min(l-n,k-h)
l=c.fx
if(l==null)l=c.fx=new Uint8Array(k)
k=h+m
c.x=k
B.j.a5(l,h,k,a0,n)
n+=m
c.y+=m
if(c.x===c.ch){c.r=1
c.x=0}break
case 4294967295:l=s.gh(a0)
k=c.ch
h=c.x
m=Math.min(l-n,k-h)
h+=m
c.x=h
n+=m
c.y+=m
if(h===k){c.r=1
c.x=0}break}c.d.az()},
co(){var s,r,q=this
switch(q.r){case 0:q.f.aE($.rU(),q.y)
q.aB()
break
case 1:if(q.x!==0){q.f.aE($.rT(),q.y)
q.aB()}else{s=q.z
r=q.y
if(s!==r)q.f.a3($.rP(),A.a([s,r],t.M),q.y)
s=q.dx
if(s!=null)s.be(new A.j2(q),q.gcp(),t.P)
else q.e.ai(0,new A.aI("model/gltf-binary",null,q.fx))}break
default:if(q.ch>0)q.f.aE($.rS(),q.y)
q.aB()}},
e0(a){var s
this.d.J()
s=this.e
if((s.a.a&30)===0)s.Y(a)}}
A.j3.prototype={
$1(a){var s
try{this.a.dZ(a)}catch(s){if(A.X(s) instanceof A.cr)this.a.aB()
else throw s}},
$S:26}
A.j4.prototype={
$0(){var s=this.a
if((s.dy.b&4)!==0)s.d.az()
else s.aB()},
$S:2}
A.j1.prototype={
$1$seen(a){var s=this.a
if(a){s.f.a3($.rJ(),A.a(["0x"+B.a.ap(B.c.aq(s.cx,16),8,"0")],t.M),s.y-8)
s.r=4294967295}else s.r=s.cx},
$0(){return this.$1$seen(null)},
$S:80}
A.j2.prototype={
$1(a){var s=this.a,r=a==null?null:a.b
s.e.ai(0,new A.aI("model/gltf-binary",r,s.fx))},
$S:81}
A.aI.prototype={}
A.dK.prototype={
bU(){var s=this,r=A.a([],t.M),q=new A.ab("")
s.d=new A.ni(new A.hr(!1),new A.mZ(B.bg.gel().a,new A.hi(new A.j5(s),r,t.cy),q),q)
s.b=s.a.b9(s.gdR(),s.gdT(),s.gdV())
return s.c.a},
dS(a){var s,r,q,p=this
p.b.bd(0)
if(p.f){r=J.S(a)
if(r.gP(a)&&239===r.j(a,0))p.e.b4($.od(),A.a(["BOM found at the beginning of UTF-8 stream."],t.M),!0)
p.f=!1}try{p.d.ee(a,0,J.a9(a),!1)
p.b.az()}catch(q){r=A.X(q)
if(r instanceof A.bk){s=r
p.e.b4($.od(),A.a([s],t.M),!0)
p.b.J()
p.c.b5(0)}else throw q}},
dW(a){var s
this.b.J()
s=this.c
if((s.a.a&30)===0)s.Y(a)},
dU(){var s,r,q,p=this
try{p.d.ah(0)}catch(r){q=A.X(r)
if(q instanceof A.bk){s=q
p.e.b4($.od(),A.a([s],t.M),!0)
p.b.J()
p.c.b5(0)}else throw r}}}
A.j5.prototype={
$1(a){var s,r,q,p=a[0]
if(t.t.b(p))try{r=this.a
s=A.vf(p,r.e)
r.c.ai(0,new A.aI("model/gltf+json",s,null))}catch(q){if(A.X(q) instanceof A.cr){r=this.a
r.b.J()
r.c.b5(0)}else throw q}else{r=this.a
r.e.b4($.ac(),A.a([p,"object"],t.M),!0)
r.b.J()
r.c.b5(0)}},
$S:83}
A.fe.prototype={
k(a){return"Resource not found ("+this.a+")."},
$iao:1}
A.nQ.prototype={
$2(a,b){var s,r
this.a.$1(a)
b=A.nH(b)
s=A.aX(b)&&b>=0
r=this.b
if(s)r.m(0,a,b)
else{r.m(0,a,-1)
this.c.n($.hH(),a)}},
$S:5}
A.nR.prototype={
$2(a,b){var s,r
this.a.$1(a)
b=A.nH(b)
s=A.aX(b)&&b>=0
r=this.b
if(s)r.m(0,a,b)
else{r.m(0,a,-1)
this.c.n($.hH(),a)}},
$S:5}
A.nS.prototype={
$1(a){return a.ag(0,t.X,t.e)},
$S:84}
A.nO.prototype={
$0(){return A.a([],t.bH)},
$S:85}
A.H.prototype={
j(a,b){return b==null||b<0||b>=this.a.length?null:this.a[b]},
m(a,b,c){this.a[b]=c},
gh(a){return this.b},
sh(a,b){throw A.c(A.a1("Changing length is not supported"))},
k(a){return A.jo(this.a,"[","]")},
a4(a){var s,r,q,p
for(s=this.b,r=this.a,q=0;q<s;++q){p=r[q]
if(p==null)continue
a.$2(q,p)}}}
A.a7.prototype={
au(a){return!0}}
A.fS.prototype={
a_(a,b,c,d){var s=this,r=s.c,q=r!=null?r.$1(d):d
r=s.a+q*q
s.a=r
if(2===c){if(Math.abs(Math.sqrt(r)-1)>0.00674)a.l($.p_(),A.a([b-2,b,Math.sqrt(s.a)],t.M),s.b)
s.a=0}return!0}}
A.fT.prototype={
a_(a,b,c,d){var s=this,r=s.c,q=r!=null?r.$1(d):d
if(3===c){if(1!==q&&-1!==q)a.l($.rp(),A.a([b-3,b,q],t.M),s.b)}else{r=s.a+q*q
s.a=r
if(2===c){if(Math.abs(Math.sqrt(r)-1)>0.00674)a.l($.p_(),A.a([b-2,b,Math.sqrt(s.a)],t.M),s.b)
s.a=0}}return!0}}
A.f1.prototype={
a_(a,b,c,d){if(1<d||0>d)a.l($.rt(),A.a([b,d],t.M),this.a)
return!0}}
A.dg.prototype={
bf(){var s,r,q,p,o,n,m=this,l=t.X,k=t._,j=A.ai(l,k)
j.m(0,"uri",m.a.k(0))
s=m.c
r=s==null
if((r?null:s.a)!=null)j.m(0,"mimeType",r?null:s.a)
j.m(0,"validatorVersion","2.0.0-dev.3.8")
j.m(0,"validatedAt",new A.ck(Date.now(),!1).eK().eJ())
s=m.b
q=s.fy
p=A.ai(l,k)
o=A.a([0,0,0,0],t.V)
n=A.pQ(q.length,new A.mo(q,o),!1,t.t)
p.m(0,"numErrors",o[0])
p.m(0,"numWarnings",o[1])
p.m(0,"numInfos",o[2])
p.m(0,"numHints",o[3])
p.m(0,"messages",n)
p.m(0,"truncated",s.z)
j.m(0,"issues",p)
s=m.dQ()
if(s!=null)j.m(0,"info",s)
return j},
dQ(){var s,r,q,p,o,n,m,l,k,j,i=null,h=this.c,g=h==null?i:h.b
h=g==null?i:g.x
if((h==null?i:h.f)==null)return i
s=A.ai(t.X,t._)
h=g.x
s.m(0,"version",h.f)
r=h.r
if(r!=null)s.m(0,"minVersion",r)
h=h.e
if(h!=null)s.m(0,"generator",h)
h=g.d
r=J.S(h)
if(r.gP(h)){h=r.bX(h)
s.m(0,"extensionsUsed",A.d8(h,!1,A.D(h).i("a4.E")))}h=g.e
r=J.S(h)
if(r.gP(h)){h=r.bX(h)
s.m(0,"extensionsRequired",A.d8(h,!1,A.D(h).i("a4.E")))}h=this.b
r=h.fr
if(!r.gv(r))s.m(0,"resources",h.fr)
s.m(0,"animationCount",g.r.b)
s.m(0,"materialCount",g.cx.b)
h=g.cy
s.m(0,"hasMorphTargets",h.aF(h,new A.mn()))
r=g.fx
s.m(0,"hasSkins",!r.gv(r))
r=g.fy
s.m(0,"hasTextures",!r.gv(r))
s.m(0,"hasDefaultScene",g.dy!=null)
for(h=new A.aq(h,h.gh(h),h.$ti.i("aq<o.E>")),q=0,p=0,o=0,n=0,m=0,l=0;h.p();){r=h.d.x
if(r!=null){q+=r.b
for(r=new A.aq(r,r.gh(r),r.$ti.i("aq<o.E>"));r.p();){k=r.d
j=k.fr
if(j!==-1)m+=j
l+=k.geL()
j=k.dx
p=Math.max(p,j.gh(j))
o=Math.max(o,k.db)
n=Math.max(n,k.cx*4)}}}s.m(0,"drawCallCount",q)
s.m(0,"totalVertexCount",m)
s.m(0,"totalTriangleCount",l)
s.m(0,"maxUVs",o)
s.m(0,"maxInfluences",n)
s.m(0,"maxAttributes",p)
return s}}
A.mo.prototype={
$1(a){var s,r=this.a[a],q=r.gbl().a,p=this.b
p[q]=p[q]+1
s=A.ou(["code",r.a.b,"message",r.gbb(r),"severity",r.gbl().a],t.X,t._)
q=r.c
if(q!=null)s.m(0,"pointer",q)
else{q=r.d
if(q!=null)s.m(0,"offset",q)}return s},
$S:86}
A.mn.prototype={
$1(a){var s=a.x
return s!=null&&s.aF(s,new A.mm())},
$S:87}
A.mm.prototype={
$1(a){return a.fx!=null},
$S:7}
A.fo.prototype={
k(a){return"[0] "+this.ac(0).k(0)+"\n[1] "+this.ac(1).k(0)+"\n[2] "+this.ac(2).k(0)+"\n"},
N(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.fo){s=this.a
r=s[0]
q=b.a
s=r===q[0]&&s[1]===q[1]&&s[2]===q[2]&&s[3]===q[3]&&s[4]===q[4]&&s[5]===q[5]&&s[6]===q[6]&&s[7]===q[7]&&s[8]===q[8]}else s=!1
return s},
gC(a){return A.kO(this.a)},
ac(a){var s=new Float32Array(3),r=this.a
s[0]=r[a]
s[1]=r[3+a]
s[2]=r[6+a]
return new A.cR(s)}}
A.da.prototype={
k(a){var s=this
return"[0] "+s.ac(0).k(0)+"\n[1] "+s.ac(1).k(0)+"\n[2] "+s.ac(2).k(0)+"\n[3] "+s.ac(3).k(0)+"\n"},
N(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.da){s=this.a
r=s[0]
q=b.a
s=r===q[0]&&s[1]===q[1]&&s[2]===q[2]&&s[3]===q[3]&&s[4]===q[4]&&s[5]===q[5]&&s[6]===q[6]&&s[7]===q[7]&&s[8]===q[8]&&s[9]===q[9]&&s[10]===q[10]&&s[11]===q[11]&&s[12]===q[12]&&s[13]===q[13]&&s[14]===q[14]&&s[15]===q[15]}else s=!1
return s},
gC(a){return A.kO(this.a)},
ac(a){var s=new Float32Array(4),r=this.a
s[0]=r[a]
s[1]=r[4+a]
s[2]=r[8+a]
s[3]=r[12+a]
return new A.fX(s)},
cK(){var s=this.a,r=s[0],q=s[5],p=s[1],o=s[4],n=r*q-p*o,m=s[6],l=s[2],k=r*m-l*o,j=s[7],i=s[3],h=r*j-i*o,g=p*m-l*q,f=p*j-i*q,e=l*j-i*m
m=s[8]
i=s[9]
j=s[10]
l=s[11]
return-(i*e-j*f+l*g)*s[12]+(m*e-j*h+l*k)*s[13]-(m*f-i*h+l*n)*s[14]+(m*g-i*k+j*n)*s[15]},
cQ(){var s=this.a,r=0+Math.abs(s[0])+Math.abs(s[1])+Math.abs(s[2])+Math.abs(s[3]),q=r>0?r:0
r=0+Math.abs(s[4])+Math.abs(s[5])+Math.abs(s[6])+Math.abs(s[7])
if(r>q)q=r
r=0+Math.abs(s[8])+Math.abs(s[9])+Math.abs(s[10])+Math.abs(s[11])
if(r>q)q=r
r=0+Math.abs(s[12])+Math.abs(s[13])+Math.abs(s[14])+Math.abs(s[15])
return r>q?r:q},
cU(){var s=this.a
return s[0]===1&&s[1]===0&&s[2]===0&&s[3]===0&&s[4]===0&&s[5]===1&&s[6]===0&&s[7]===0&&s[8]===0&&s[9]===0&&s[10]===1&&s[11]===0&&s[12]===0&&s[13]===0&&s[14]===0&&s[15]===1}}
A.fH.prototype={
gaM(){var s=this.a,r=s[0],q=s[1],p=s[2],o=s[3]
return r*r+q*q+p*p+o*o},
gh(a){var s=this.a,r=s[0],q=s[1],p=s[2],o=s[3]
return Math.sqrt(r*r+q*q+p*p+o*o)},
k(a){var s=this.a
return A.b(s[0])+", "+A.b(s[1])+", "+A.b(s[2])+" @ "+A.b(s[3])}}
A.cR.prototype={
bk(a,b,c){var s=this.a
s[0]=a
s[1]=b
s[2]=c},
k(a){var s=this.a
return"["+A.b(s[0])+","+A.b(s[1])+","+A.b(s[2])+"]"},
N(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.cR){s=this.a
r=s[0]
q=b.a
s=r===q[0]&&s[1]===q[1]&&s[2]===q[2]}else s=!1
return s},
gC(a){return A.kO(this.a)},
gh(a){var s=this.a,r=s[0],q=s[1]
s=s[2]
return Math.sqrt(r*r+q*q+s*s)},
gaM(){var s=this.a,r=s[0],q=s[1]
s=s[2]
return r*r+q*q+s*s}}
A.fX.prototype={
k(a){var s=this.a
return A.b(s[0])+","+A.b(s[1])+","+A.b(s[2])+","+A.b(s[3])},
N(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.fX){s=this.a
r=s[0]
q=b.a
s=r===q[0]&&s[1]===q[1]&&s[2]===q[2]&&s[3]===q[3]}else s=!1
return s},
gC(a){return A.kO(this.a)},
gh(a){var s=this.a,r=s[0],q=s[1],p=s[2]
s=s[3]
return Math.sqrt(r*r+q*q+p*p+s*s)}}
A.o_.prototype={
$1(a){J.ol($.eS()).w(0,"hover");++this.a.a},
$S:3}
A.o0.prototype={
$1(a){a.preventDefault()},
$S:3}
A.o1.prototype={
$1(a){if(--this.a.a===0)J.ol($.eS()).ax(0,"hover")},
$S:3}
A.o2.prototype={
$1(a){a.preventDefault()
A.qP(a.dataTransfer.files)},
$S:3}
A.o3.prototype={
$1(a){var s
a.preventDefault()
s=$.oh()
s.value=""
s.click()},
$S:3}
A.o4.prototype={
$1(a){var s,r
a.preventDefault()
s=$.oh()
r=s.files
r.toString
if(!B.ab.gv(r))A.qP(s.files)},
$S:89}
A.nI.prototype={
$1(a){var s,r,q=$.eS(),p=J.eO(q)
p.gaH(q).ax(0,"drop")
if(a!=null){s=a.b
if(s.z){r=$.pq().style
r.display="block"}s=s.gen()
if(!s.gD(s).p()){p.gaH(q).w(0,"valid")
$.hI().textContent="The asset is valid."}else{p.gaH(q).w(0,"invalid")
$.hI().textContent="The asset contains errors."}}else $.hI().textContent="No glTF asset provided."},
$S:90}
A.nu.prototype={
$1(a){var s
if(a!=null){s=A.qF(this.a,a)
if(s!=null)return A.nw(s)
else throw A.c(A.pI(a.k(0)))}else return this.b.c},
$0(){return this.$1(null)},
$C:"$1",
$R:0,
$D(){return[null]},
$S:91}
A.nv.prototype={
$1(a){var s
if(a!=null){s=A.qF(this.a,a)
if(s!=null)return A.oL(s)
else throw A.c(A.pI(a.k(0)))}return null},
$S:92}
A.nx.prototype={
$1(a){return a.name===this.a},
$S:93}
A.ny.prototype={
$0(){return null},
$S:2}
A.nA.prototype={
$0(){this.a.a=!0},
$S:2}
A.nB.prototype={
$0(){var s,r,q={}
q.a=0
s=new FileReader()
r=this.c
A.cU(s,"loadend",new A.nz(this.a,q,s,this.b,r),!1)
q=q.a+=Math.min(1048576,A.xT(r.size))
s.readAsArrayBuffer(r.slice(0,q))},
$S:2}
A.nz.prototype={
$1(a){var s,r,q,p,o,n,m,l=this
if(l.a.a)return
s=l.c
r=B.ac.gda(s)
if(t.Z.b(r))l.d.w(0,r)
q=l.b
p=q.a
o=l.e
n=o.size
if(p<n){m=p+Math.min(1048576,n-p)
q.a=m
s.readAsArrayBuffer(o.slice(p,m))}else l.d.ah(0)},
$S:142};(function aliases(){var s=J.dM.prototype
s.dr=s.k
s.dq=s.bc
s=J.cI.prototype
s.dz=s.k
s=A.aD.prototype
s.ds=s.cR
s.dt=s.cS
s.du=s.cT
s=A.o.prototype
s.dA=s.a5
s=A.ew.prototype
s.dD=s.ah
s=A.e.prototype
s.dB=s.k
s=A.bo.prototype
s.dv=s.j
s.dw=s.m
s=A.dm.prototype
s.c4=s.m
s=A.bt.prototype
s.dC=s.q})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers._instance_2u,p=hunkHelpers._instance_0u,o=hunkHelpers.installInstanceTearOff,n=hunkHelpers._static_2,m=hunkHelpers._instance_1i,l=hunkHelpers._instance_1u
s(A,"xl","vd",95)
r(A,"xm","vV",15)
s(A,"xK","we",12)
s(A,"xL","wf",12)
s(A,"xM","wg",12)
r(A,"qT","xx",1)
s(A,"xN","xp",17)
q(A.I.prototype,"gci","am",38)
var k
p(k=A.ei.prototype,"gcq","aZ",1)
p(k,"gcr","b_",1)
o(k=A.ee.prototype,"geA",1,0,null,["$1","$0"],["d5","bd"],53,0,0)
p(k,"geC","az",1)
p(k,"gcq","aZ",1)
p(k,"gcr","b_",1)
n(A,"xV","x2",97)
m(A.ba.prototype,"gcH","I",14)
s(A,"qU","x3",4)
s(A,"ye","oI",98)
s(A,"yd","oH",99)
n(A,"xG","uP",100)
n(A,"xF","uO",101)
n(A,"xD","uM",102)
n(A,"xE","uN",103)
l(A.ad.prototype,"gbQ","ez",33)
n(A,"xI","uR",104)
n(A,"xH","uQ",105)
n(A,"xJ","uS",106)
n(A,"xO","uW",107)
n(A,"xP","uV",108)
n(A,"xS","uZ",109)
n(A,"xQ","uX",110)
n(A,"xR","uY",111)
n(A,"y6","vh",112)
n(A,"yx","vG",113)
n(A,"yz","vR",114)
n(A,"yy","vQ",115)
n(A,"r6","vP",116)
n(A,"az","w8",117)
n(A,"yA","vK",118)
n(A,"yB","vO",119)
n(A,"yD","w3",120)
n(A,"yE","w4",121)
n(A,"yF","w5",122)
n(A,"yH","w9",123)
s(A,"dx","xs",28)
s(A,"qW","xn",28)
s(A,"y_","x8",13)
n(A,"xZ","vc",126)
n(A,"yf","vo",127)
n(A,"yg","vp",128)
n(A,"yh","vq",129)
n(A,"yi","vr",130)
n(A,"yj","vs",131)
n(A,"yk","vt",132)
n(A,"yl","vu",133)
n(A,"ym","vv",134)
n(A,"yn","vw",135)
n(A,"yo","vx",136)
n(A,"yp","vy",137)
n(A,"yq","vz",138)
n(A,"vm","vA",139)
n(A,"vn","vB",140)
n(A,"yr","vC",141)
n(A,"yt","vD",94)
p(k=A.fc.prototype,"ge_","co",1)
l(k,"gcp","e0",27)
l(k=A.dK.prototype,"gdR","dS",82)
l(k,"gdV","dW",27)
p(k,"gdT","dU",1)
s(A,"ys","x9",13)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.mixinHard,q=hunkHelpers.inherit,p=hunkHelpers.inheritMany
q(A.e,null)
p(A.e,[A.os,J.dM,J.bf,A.t,A.dA,A.N,A.cj,A.G,A.em,A.aq,A.R,A.dE,A.dH,A.fV,A.de,A.dY,A.d3,A.jq,A.ma,A.fD,A.dF,A.et,A.n9,A.kr,A.dV,A.jr,A.n7,A.aT,A.hc,A.ey,A.nf,A.h_,A.dl,A.aL,A.eZ,A.h2,A.bX,A.I,A.h0,A.aV,A.fO,A.fP,A.hk,A.h1,A.ee,A.h5,A.mG,A.hh,A.hl,A.nk,A.eH,A.n5,A.cV,A.o,A.hp,A.a4,A.es,A.hq,A.m9,A.f4,A.mE,A.f0,A.n2,A.n_,A.hr,A.ck,A.mH,A.fE,A.e8,A.h9,A.bk,A.d9,A.m,A.hm,A.m3,A.ab,A.eE,A.mc,A.hj,A.i6,A.op,A.bl,A.dI,A.bo,A.hd,A.a7,A.r,A.ce,A.cb,A.B,A.ml,A.i,A.cr,A.cq,A.jh,A.ec,A.eb,A.aO,A.fJ,A.kV,A.fi,A.jn,A.bJ,A.U,A.Z,A.cn,A.cJ,A.fK,A.fc,A.aI,A.dK,A.fe,A.dg,A.fo,A.da,A.fH,A.cR,A.fX])
p(J.dM,[J.dO,J.dQ,J.aC,J.E,J.cs,J.bK,A.ft,A.cK])
p(J.aC,[J.cI,A.f9,A.cd,A.h3,A.iH,A.iI,A.j,A.ha,A.dL,A.kt,A.ht,A.dT])
p(J.cI,[J.fF,J.bU,J.bn])
q(J.js,J.E)
p(J.cs,[J.dP,J.fk])
p(A.t,[A.bW,A.n,A.br,A.ed,A.bs,A.eh,A.dN])
p(A.bW,[A.ch,A.eG])
q(A.ej,A.ch)
q(A.ef,A.eG)
q(A.bg,A.ef)
q(A.dX,A.N)
p(A.dX,[A.ci,A.aD,A.he])
p(A.cj,[A.f3,A.f2,A.iK,A.fQ,A.jw,A.nV,A.nX,A.mB,A.mA,A.nl,A.mO,A.mW,A.m6,A.m5,A.nc,A.n4,A.kv,A.ns,A.nt,A.mI,A.mJ,A.i4,A.i5,A.np,A.nq,A.nK,A.nL,A.nM,A.mx,A.my,A.mu,A.mv,A.mr,A.ms,A.jd,A.je,A.j6,A.jf,A.ky,A.kz,A.kA,A.kE,A.kL,A.kM,A.kN,A.kY,A.m2,A.hX,A.hY,A.hZ,A.i1,A.i_,A.ji,A.jk,A.jv,A.ju,A.kW,A.kX,A.o9,A.nG,A.iw,A.ix,A.ip,A.io,A.ic,A.ib,A.it,A.ij,A.ia,A.iq,A.ih,A.id,A.ig,A.ie,A.i8,A.i9,A.is,A.ir,A.ii,A.iz,A.iB,A.iE,A.iF,A.iC,A.iD,A.iA,A.iG,A.iy,A.il,A.ik,A.iu,A.iv,A.im,A.jm,A.l0,A.l1,A.l_,A.l3,A.l4,A.l5,A.l2,A.l6,A.l7,A.l8,A.ld,A.le,A.lc,A.l9,A.la,A.lb,A.lZ,A.m_,A.lK,A.lu,A.lh,A.li,A.lg,A.lj,A.lk,A.ll,A.ln,A.lm,A.lo,A.lp,A.lq,A.lr,A.lC,A.lF,A.lJ,A.lH,A.lE,A.lI,A.lG,A.lD,A.lO,A.lM,A.lP,A.lW,A.m1,A.lV,A.m0,A.lt,A.lN,A.lS,A.lR,A.lQ,A.lX,A.lY,A.lU,A.lL,A.lT,A.ls,A.lv,A.lw,A.lB,A.lA,A.ly,A.lx,A.lz,A.jI,A.jG,A.jH,A.jJ,A.jM,A.jK,A.jL,A.jQ,A.jO,A.jS,A.jP,A.jR,A.jN,A.jT,A.jW,A.jV,A.jU,A.jX,A.jY,A.k1,A.k2,A.k8,A.k0,A.k_,A.k5,A.k4,A.k3,A.k9,A.ka,A.k7,A.k6,A.kb,A.kc,A.kf,A.kd,A.ke,A.kg,A.ki,A.kh,A.kj,A.kk,A.kl,A.km,A.kn,A.kq,A.kp,A.ko,A.jZ,A.iS,A.iT,A.iV,A.iM,A.iU,A.iN,A.iQ,A.iP,A.iO,A.iY,A.iX,A.iZ,A.j_,A.iW,A.j0,A.iR,A.jB,A.jE,A.j3,A.j1,A.j2,A.j5,A.nS,A.mo,A.mn,A.mm,A.o_,A.o0,A.o1,A.o2,A.o3,A.o4,A.nI,A.nu,A.nv,A.nx,A.nz])
p(A.f3,[A.hV,A.kR,A.nW,A.nm,A.nJ,A.mP,A.ku,A.n3,A.n0,A.kK,A.me,A.mf,A.mg,A.nr,A.hK,A.hL,A.ja,A.jb,A.j8,A.j9,A.jg,A.kx,A.kH,A.kG,A.kC,A.kD,A.kF,A.i3,A.o8,A.oa,A.jz,A.jA,A.jD,A.jC,A.nQ,A.nR])
p(A.G,[A.fn,A.fI,A.e1,A.b6,A.fl,A.fU,A.fL,A.h7,A.dS,A.eY,A.fC,A.aN,A.fB,A.fW,A.fR,A.bR,A.f5,A.f8])
q(A.dW,A.em)
p(A.dW,[A.df,A.H])
p(A.df,[A.d2,A.b7])
p(A.f2,[A.o6,A.kS,A.mC,A.mD,A.ng,A.mK,A.mS,A.mQ,A.mM,A.mR,A.mL,A.mV,A.mU,A.mT,A.m7,A.m4,A.ne,A.nd,A.mF,A.n8,A.nn,A.nF,A.nb,A.mk,A.mj,A.mw,A.mz,A.mq,A.mt,A.jc,A.j7,A.kB,A.hW,A.i2,A.i0,A.jj,A.kQ,A.j4,A.nO,A.ny,A.nA,A.nB])
p(A.n,[A.aj,A.bj,A.dU])
p(A.aj,[A.e9,A.a8,A.hf,A.ek])
q(A.bi,A.br)
p(A.R,[A.dZ,A.cS,A.e7])
q(A.d4,A.bs)
q(A.eC,A.dY)
q(A.bw,A.eC)
q(A.dB,A.bw)
p(A.d3,[A.aA,A.a5])
q(A.e2,A.b6)
p(A.fQ,[A.fN,A.d1])
q(A.db,A.cK)
p(A.db,[A.eo,A.eq])
q(A.ep,A.eo)
q(A.e_,A.ep)
q(A.er,A.eq)
q(A.aF,A.er)
p(A.e_,[A.fu,A.fv])
p(A.aF,[A.fw,A.fx,A.fy,A.fz,A.fA,A.e0,A.cL])
q(A.ez,A.h7)
q(A.ex,A.dN)
q(A.by,A.h2)
q(A.b8,A.hk)
p(A.aV,[A.eu,A.cT])
q(A.b9,A.eu)
q(A.ei,A.ee)
q(A.dj,A.h5)
q(A.ev,A.hh)
q(A.na,A.nk)
p(A.aD,[A.n6,A.el])
q(A.dn,A.eH)
p(A.dn,[A.ba,A.eI])
q(A.e6,A.es)
q(A.eD,A.eI)
q(A.m8,A.m9)
q(A.ew,A.m8)
q(A.mZ,A.ew)
p(A.f4,[A.hQ,A.iJ,A.jx])
q(A.f6,A.fP)
p(A.f6,[A.hS,A.hR,A.jy,A.mi])
p(A.f0,[A.hT,A.hi])
q(A.fm,A.dS)
q(A.hg,A.n2)
q(A.hs,A.hg)
q(A.n1,A.hs)
q(A.ni,A.hT)
q(A.mh,A.iJ)
p(A.aN,[A.e5,A.fh])
q(A.h4,A.eE)
p(A.f9,[A.M,A.fa,A.dh,A.bx])
p(A.M,[A.dD,A.b0])
p(A.dD,[A.k,A.l])
p(A.k,[A.eU,A.eW,A.fb,A.fM])
q(A.dC,A.h3)
q(A.as,A.cd)
q(A.hb,A.ha)
q(A.dG,A.hb)
p(A.j,[A.aW,A.b3])
q(A.aK,A.aW)
q(A.hu,A.ht)
q(A.en,A.hu)
q(A.f7,A.e6)
p(A.f7,[A.h6,A.f_])
q(A.ax,A.cT)
q(A.h8,A.fO)
p(A.bo,[A.dR,A.dm])
q(A.ct,A.dm)
q(A.p,A.hd)
p(A.p,[A.fd,A.c8,A.c9,A.ca,A.bd,A.cc,A.be,A.bG,A.cf,A.cg,A.dJ,A.cO,A.bt,A.aJ,A.cm,A.bL,A.cu,A.cv,A.cw,A.cx,A.cy,A.cz,A.cA,A.cB,A.cC,A.cD,A.cE,A.bM,A.cF,A.bq,A.cG,A.cH])
p(A.fd,[A.ad,A.bF,A.b_,A.bH,A.bI,A.b1,A.aE,A.b2,A.at,A.bO,A.bP,A.bQ,A.bT,A.bp,A.aP])
p(A.ad,[A.fZ,A.fY])
p(A.a7,[A.fj,A.fr,A.fp,A.fs,A.fq,A.eV,A.e4,A.fg,A.ff,A.fS,A.fT,A.f1])
p(A.bt,[A.cN,A.cM])
p(A.mH,[A.d5,A.eg,A.di,A.co,A.dp,A.dd])
p(A.jh,[A.jt,A.kP,A.mp])
p(A.jn,[A.i7,A.jl,A.kZ,A.lf,A.jF,A.iL])
s(A.df,A.fV)
s(A.eG,A.o)
s(A.eo,A.o)
s(A.ep,A.dH)
s(A.eq,A.o)
s(A.er,A.dH)
s(A.b8,A.h1)
s(A.em,A.o)
s(A.es,A.a4)
s(A.eC,A.hp)
s(A.eH,A.a4)
s(A.eI,A.hq)
s(A.hs,A.n_)
s(A.h3,A.i6)
s(A.ha,A.o)
s(A.hb,A.bl)
s(A.ht,A.o)
s(A.hu,A.bl)
r(A.dm,A.o)
s(A.hd,A.r)})()
var v={typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{f:"int",C:"double",Q:"num",d:"String",J:"bool",m:"Null",q:"List"},mangledNames:{},types:["d*(q<@>*)","~()","m()","m(aK*)","@(@)","m(d*,e*)","m(d*,f*)","J*(aJ*)","~(e?,e?)","C*(f*)","J*(f*)","m(at*,f*,f*)","~(~())","~(i*)","J(e?)","f()","m(@)","~(@)","@()","~(aw,d,f)","~(j)","t<f*>*()","t<C*>*()","m(f*,aJ*)","~(d*)","J*(U*)","m(q<f*>*)","~(e*)","d*(e*)","J*(at*)","dR(@)","ct<@>(@)","bo(@)","C*(Q*)","m(@,aU)","t<f*>*(f*,f*,f*)","f*(f*)","~(f,@)","~(e,aU)","t<C*>*(f*,f*,f*)","m(f*,be*)","m(f*,bd*)","H<0^*>*(d*,0^*(h<d*,e*>*,i*)*)<e*>","0^*(d*,0^*(h<d*,e*>*,i*)*{req:J*})<e*>","~(H<p*>*,bu*)","m(f*,p*)","m(e,aU)","m(f*,at*)","aB<m>()","~(H<cP*>*)","m(f*,cP*)","~(p*,d*)","I<@>(@)","~([aB<~>?])","f*(f*,f*,d*)","J(@)","m(~())","ak<ad<Q*>*>*()","@(@,d)","~(cQ,@)","d*(U*)","q<a7<Q*>*>*()","J*(bJ*)","d*(d*)","~(d,f)","U*()","m(bu*,Z*)","~(d,f?)","m(e*)","aw*/*(b_*)","aV<q<f*>*>*(b1*)","m(f*,ad<Q*>*)","J*(R<Q*>*)","f(f,f)","m(f*,bp*)","m(f*,aP*)","m(f*,bq*)","aP*(f*)","J*(e*)","aw(@,@)","~({seen:J*})","m(aI*)","~(q<f*>*)","m(q<e*>*)","h<d*,f*>*(h<@,@>*)","q<cJ*>*()","h<d*,e*>*(f*)","J*(b2*)","@(d)","m(j*)","m(dg*)","aw*/*([bV*])","aV<aw*>*(bV*)","J*(as*)","cH*(h<d*,e*>*,i*)","f(e?)","~(d,@)","J(e?,e?)","e?(e?)","e?(@)","ad<Q*>*(h<d*,e*>*,i*)","c8*(h<d*,e*>*,i*)","c9*(h<d*,e*>*,i*)","ca*(h<d*,e*>*,i*)","bF*(h<d*,e*>*,i*)","cc*(h<d*,e*>*,i*)","bG*(h<d*,e*>*,i*)","b_*(h<d*,e*>*,i*)","bH*(h<d*,e*>*,i*)","bI*(h<d*,e*>*,i*)","cf*(h<d*,e*>*,i*)","cg*(h<d*,e*>*,i*)","b1*(h<d*,e*>*,i*)","aE*(h<d*,e*>*,i*)","cO*(h<d*,e*>*,i*)","cN*(h<d*,e*>*,i*)","cM*(h<d*,e*>*,i*)","bt*(h<d*,e*>*,i*)","b2*(h<d*,e*>*,i*)","at*(h<d*,e*>*,i*)","bO*(h<d*,e*>*,i*)","bP*(h<d*,e*>*,i*)","bQ*(h<d*,e*>*,i*)","bT*(h<d*,e*>*,i*)","J(ak<d>)","~(ak<d>)","cm*(h<d*,e*>*,i*)","bL*(h<d*,e*>*,i*)","cu*(h<d*,e*>*,i*)","cv*(h<d*,e*>*,i*)","cw*(h<d*,e*>*,i*)","cx*(h<d*,e*>*,i*)","cy*(h<d*,e*>*,i*)","cz*(h<d*,e*>*,i*)","cA*(h<d*,e*>*,i*)","cB*(h<d*,e*>*,i*)","cC*(h<d*,e*>*,i*)","cD*(h<d*,e*>*,i*)","cE*(h<d*,e*>*,i*)","bM*(h<d*,e*>*,i*)","cF*(h<d*,e*>*,i*)","cG*(h<d*,e*>*,i*)","m(b3*)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.wC(v.typeUniverse,JSON.parse('{"fF":"cI","bU":"cI","bn":"cI","yO":"j","zu":"j","yN":"l","zM":"l","BY":"b3","yQ":"k","AA":"k","zN":"M","zt":"M","AC":"aK","yS":"aW","zs":"bx","yR":"b0","BH":"b0","AB":"cK","dO":{"J":[]},"dQ":{"m":[]},"E":{"q":["1"],"n":["1"]},"js":{"E":["1"],"q":["1"],"n":["1"]},"bf":{"R":["1"]},"cs":{"C":[],"Q":[]},"dP":{"C":[],"f":[],"Q":[]},"fk":{"C":[],"Q":[]},"bK":{"d":[]},"bW":{"t":["2"]},"dA":{"R":["2"]},"ch":{"bW":["1","2"],"t":["2"],"t.E":"2"},"ej":{"ch":["1","2"],"bW":["1","2"],"n":["2"],"t":["2"],"t.E":"2"},"ef":{"o":["2"],"q":["2"],"bW":["1","2"],"n":["2"],"t":["2"]},"bg":{"ef":["1","2"],"o":["2"],"q":["2"],"bW":["1","2"],"n":["2"],"t":["2"],"o.E":"2","t.E":"2"},"ci":{"N":["3","4"],"h":["3","4"],"N.K":"3","N.V":"4"},"fn":{"G":[]},"fI":{"G":[]},"d2":{"o":["f"],"q":["f"],"n":["f"],"o.E":"f"},"e1":{"b6":[],"G":[]},"n":{"t":["1"]},"aj":{"n":["1"],"t":["1"]},"e9":{"aj":["1"],"n":["1"],"t":["1"],"t.E":"1","aj.E":"1"},"aq":{"R":["1"]},"br":{"t":["2"],"t.E":"2"},"bi":{"br":["1","2"],"n":["2"],"t":["2"],"t.E":"2"},"dZ":{"R":["2"]},"a8":{"aj":["2"],"n":["2"],"t":["2"],"t.E":"2","aj.E":"2"},"ed":{"t":["1"],"t.E":"1"},"cS":{"R":["1"]},"bs":{"t":["1"],"t.E":"1"},"d4":{"bs":["1"],"n":["1"],"t":["1"],"t.E":"1"},"e7":{"R":["1"]},"bj":{"n":["1"],"t":["1"],"t.E":"1"},"dE":{"R":["1"]},"df":{"o":["1"],"q":["1"],"n":["1"]},"de":{"cQ":[]},"dB":{"bw":["1","2"],"h":["1","2"]},"d3":{"h":["1","2"]},"aA":{"d3":["1","2"],"h":["1","2"]},"eh":{"t":["1"],"t.E":"1"},"a5":{"d3":["1","2"],"h":["1","2"]},"e2":{"b6":[],"G":[]},"fl":{"G":[]},"fU":{"G":[]},"fD":{"ao":[]},"et":{"aU":[]},"cj":{"cp":[]},"f2":{"cp":[]},"f3":{"cp":[]},"fQ":{"cp":[]},"fN":{"cp":[]},"d1":{"cp":[]},"fL":{"G":[]},"aD":{"N":["1","2"],"h":["1","2"],"N.K":"1","N.V":"2"},"dU":{"n":["1"],"t":["1"],"t.E":"1"},"dV":{"R":["1"]},"ft":{"pE":[]},"cK":{"av":[]},"db":{"ae":["1"],"av":[]},"e_":{"o":["C"],"ae":["C"],"q":["C"],"n":["C"],"av":[]},"aF":{"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[]},"fu":{"o":["C"],"ae":["C"],"q":["C"],"n":["C"],"av":[],"o.E":"C"},"fv":{"o":["C"],"ae":["C"],"q":["C"],"n":["C"],"av":[],"o.E":"C"},"fw":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"fx":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"fy":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"fz":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"fA":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"e0":{"aF":[],"o":["f"],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"cL":{"aF":[],"o":["f"],"aw":[],"ae":["f"],"q":["f"],"n":["f"],"av":[],"o.E":"f"},"ey":{"bu":[]},"h7":{"G":[]},"ez":{"b6":[],"G":[]},"I":{"aB":["1"]},"aL":{"R":["1"]},"ex":{"t":["1"],"t.E":"1"},"eZ":{"G":[]},"by":{"h2":["1"]},"b8":{"hk":["1"]},"b9":{"aV":["1"]},"eu":{"aV":["1"]},"n6":{"aD":["1","2"],"N":["1","2"],"h":["1","2"],"N.K":"1","N.V":"2"},"el":{"aD":["1","2"],"N":["1","2"],"h":["1","2"],"N.K":"1","N.V":"2"},"ba":{"dn":["1"],"a4":["1"],"ak":["1"],"n":["1"],"a4.E":"1"},"cV":{"R":["1"]},"b7":{"o":["1"],"q":["1"],"n":["1"],"o.E":"1"},"dN":{"t":["1"]},"dW":{"o":["1"],"q":["1"],"n":["1"]},"dX":{"N":["1","2"],"h":["1","2"]},"N":{"h":["1","2"]},"dY":{"h":["1","2"]},"bw":{"h":["1","2"]},"e6":{"a4":["1"],"ak":["1"],"n":["1"]},"dn":{"a4":["1"],"ak":["1"],"n":["1"]},"eD":{"dn":["1"],"a4":["1"],"ak":["1"],"n":["1"],"a4.E":"1"},"he":{"N":["d","@"],"h":["d","@"],"N.K":"d","N.V":"@"},"hf":{"aj":["d"],"n":["d"],"t":["d"],"t.E":"d","aj.E":"d"},"dS":{"G":[]},"fm":{"G":[]},"C":{"Q":[]},"f":{"Q":[]},"q":{"n":["1"]},"ak":{"n":["1"],"t":["1"]},"eY":{"G":[]},"b6":{"G":[]},"fC":{"G":[]},"aN":{"G":[]},"e5":{"G":[]},"fh":{"G":[]},"fB":{"G":[]},"fW":{"G":[]},"fR":{"G":[]},"bR":{"G":[]},"f5":{"G":[]},"fE":{"G":[]},"e8":{"G":[]},"f8":{"G":[]},"h9":{"ao":[]},"bk":{"ao":[]},"ek":{"aj":["1"],"n":["1"],"t":["1"],"t.E":"1","aj.E":"1"},"hm":{"aU":[]},"eE":{"bV":[]},"hj":{"bV":[]},"h4":{"bV":[]},"as":{"cd":[]},"aK":{"j":[]},"b3":{"j":[]},"k":{"M":[]},"eU":{"M":[]},"eW":{"M":[]},"b0":{"M":[]},"dD":{"M":[]},"dG":{"o":["as"],"bl":["as"],"q":["as"],"ae":["as"],"n":["as"],"bl.E":"as","o.E":"as"},"fb":{"M":[]},"fM":{"M":[]},"aW":{"j":[]},"en":{"o":["M"],"bl":["M"],"q":["M"],"ae":["M"],"n":["M"],"bl.E":"M","o.E":"M"},"h6":{"a4":["d"],"ak":["d"],"n":["d"],"a4.E":"d"},"cT":{"aV":["1"]},"ax":{"cT":["1"],"aV":["1"]},"dI":{"R":["1"]},"f7":{"a4":["d"],"ak":["d"],"n":["d"]},"ct":{"o":["1"],"q":["1"],"n":["1"],"o.E":"1"},"f_":{"a4":["d"],"ak":["d"],"n":["d"],"a4.E":"d"},"l":{"M":[]},"ad":{"p":[],"r":[],"u":[]},"c8":{"p":[],"r":[],"u":[]},"c9":{"p":[],"r":[],"u":[]},"ca":{"p":[],"r":[],"u":[]},"fZ":{"ad":["f*"],"p":[],"r":[],"u":[]},"fY":{"ad":["C*"],"p":[],"r":[],"u":[]},"fj":{"a7":["C*"]},"fr":{"a7":["C*"]},"fp":{"a7":["C*"]},"fs":{"a7":["f*"]},"fq":{"a7":["f*"]},"bF":{"p":[],"r":[],"u":[]},"bd":{"p":[],"r":[],"u":[]},"cc":{"p":[],"r":[],"u":[]},"be":{"p":[],"r":[],"u":[]},"eV":{"a7":["C*"]},"e4":{"a7":["1*"]},"bG":{"p":[],"r":[],"u":[]},"b_":{"p":[],"r":[],"u":[]},"bH":{"p":[],"r":[],"u":[]},"bI":{"p":[],"r":[],"u":[]},"cf":{"p":[],"r":[],"u":[]},"cg":{"p":[],"r":[],"u":[]},"dJ":{"p":[],"r":[],"u":[]},"p":{"r":[],"u":[]},"fd":{"p":[],"r":[],"u":[]},"b1":{"p":[],"r":[],"u":[]},"aE":{"p":[],"r":[],"u":[]},"cO":{"p":[],"r":[],"u":[]},"cN":{"p":[],"r":[],"u":[]},"cM":{"p":[],"r":[],"u":[]},"bt":{"p":[],"r":[],"u":[]},"b2":{"p":[],"r":[],"u":[]},"aJ":{"p":[],"r":[],"u":[]},"fg":{"a7":["f*"]},"at":{"p":[],"r":[],"u":[]},"bO":{"p":[],"r":[],"u":[]},"bP":{"p":[],"r":[],"u":[]},"bQ":{"p":[],"r":[],"u":[]},"ff":{"a7":["C*"]},"bT":{"p":[],"r":[],"u":[],"cP":[]},"cr":{"ao":[]},"ec":{"ao":[]},"eb":{"ao":[]},"aO":{"ao":[]},"cm":{"p":[],"r":[],"u":[],"cP":[]},"bL":{"p":[],"r":[],"u":[]},"bp":{"p":[],"r":[],"u":[]},"cu":{"p":[],"r":[],"u":[]},"cv":{"p":[],"r":[],"u":[]},"cw":{"p":[],"r":[],"u":[]},"cx":{"p":[],"r":[],"u":[]},"cy":{"p":[],"r":[],"u":[]},"cz":{"p":[],"r":[],"u":[]},"cA":{"p":[],"r":[],"u":[]},"cB":{"p":[],"r":[],"u":[]},"cC":{"p":[],"r":[],"u":[]},"cD":{"p":[],"r":[],"u":[]},"cE":{"p":[],"r":[],"u":[]},"bM":{"p":[],"r":[],"u":[]},"aP":{"p":[],"r":[],"u":[]},"cF":{"p":[],"r":[],"u":[]},"bq":{"p":[],"r":[],"u":[]},"cG":{"p":[],"r":[],"u":[]},"cH":{"p":[],"r":[],"u":[]},"fe":{"ao":[]},"H":{"o":["1*"],"q":["1*"],"n":["1*"],"o.E":"1*"},"fS":{"a7":["Q*"]},"fT":{"a7":["Q*"]},"f1":{"a7":["C*"]},"aw":{"q":["f"],"n":["f"],"av":[]}}'))
A.wB(v.typeUniverse,JSON.parse('{"dH":1,"fV":1,"df":1,"eG":2,"db":1,"fO":1,"fP":2,"h1":1,"ei":1,"ee":1,"eu":1,"h5":1,"dj":1,"hh":1,"ev":1,"hl":1,"dN":1,"dW":1,"dX":2,"hp":2,"dY":2,"e6":1,"hq":1,"em":1,"es":1,"eC":2,"eH":1,"eI":1,"f0":1,"f4":2,"f6":2,"ew":1,"h8":1,"dm":1}'))
var u={p:") does not match the number of morph targets (",d:"Accessor sparse indices element at index ",m:"Animation input accessor element at index ",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",g:"`null` encountered as the result from expression with type `Never`."}
var t=(function rtii(){var s=A.aM
return{r:s("cd"),dI:s("pE"),gF:s("dB<cQ,@>"),U:s("n<@>"),a:s("G"),A:s("j"),k:s("cp"),d:s("aB<@>"),bq:s("aB<~>"),N:s("a5<bu*,Z*>"),gb:s("dL"),s:s("E<d>"),gN:s("E<aw>"),b:s("E<@>"),Y:s("E<f>"),p:s("E<B*>"),gd:s("E<a7<Q*>*>"),bd:s("E<fi*>"),a9:s("E<bJ*>"),b2:s("E<R<Q*>*>"),bH:s("E<cJ*>"),fh:s("E<h<d*,e*>*>"),M:s("E<e*>"),d6:s("E<fK*>"),i:s("E<d*>"),ff:s("E<J*>"),o:s("E<C*>"),V:s("E<f*>"),T:s("dQ"),g:s("bn"),aU:s("ae<@>"),am:s("ct<@>"),eo:s("aD<cQ,@>"),dz:s("dT"),aH:s("q<@>"),eO:s("h<@,@>"),gw:s("a8<U*,d*>"),eB:s("aF"),bm:s("cL"),a0:s("M"),P:s("m"),K:s("e"),ed:s("e4<Q*>"),eq:s("H<bd*>"),az:s("H<be*>"),E:s("H<bp*>"),B:s("H<bq*>"),u:s("H<aP*>"),b_:s("H<aJ*>"),gm:s("aU"),R:s("d"),fo:s("cQ"),dd:s("bu"),eK:s("b6"),Q:s("av"),gc:s("aw"),ak:s("bU"),go:s("b7<h<d*,e*>*>"),em:s("b7<d*>"),f8:s("bw<cn*,Z*>"),l:s("bV"),g4:s("dh"),g2:s("bx"),j:s("by<aI*>"),eP:s("by<cq*>"),f1:s("b8<q<f*>*>"),G:s("ax<aK*>"),cV:s("cT<b3*>"),ck:s("I<m>"),eI:s("I<@>"),fJ:s("I<f>"),f:s("I<aI*>"),dD:s("I<cq*>"),D:s("I<~>"),cy:s("hi<e*>"),y:s("J"),gR:s("C"),z:s("@"),v:s("@(e)"),C:s("@(e,aU)"),S:s("f"),aD:s("B*"),W:s("ad<Q*>*"),bj:s("bF*"),aA:s("bd*"),hc:s("be*"),gP:s("bG*"),cT:s("b_*"),n:s("bH*"),h2:s("bI*"),x:s("ao*"),af:s("U*"),f9:s("Z*"),al:s("cn*"),ec:s("b1*"),ga:s("R<C*>*"),bF:s("R<f*>*"),cp:s("bp*"),aa:s("bq*"),q:s("aP*"),c:s("u*"),b7:s("q<a7<Q*>*>*"),an:s("q<cJ*>*"),m:s("q<e*>*"),eG:s("q<d*>*"),w:s("q<f*>*"),h:s("h<@,@>*"),gj:s("h<d*,ad<Q*>*>*"),t:s("h<d*,e*>*"),fC:s("aE*"),eM:s("b2*"),ft:s("aJ*"),I:s("0&*"),L:s("at*"),_:s("e*"),ax:s("cP*"),b5:s("H<r*>*"),c2:s("bO*"),J:s("bP*"),cn:s("ak<B*>*"),gz:s("ak<ad<Q*>*>*"),aV:s("bQ*"),X:s("d*"),ai:s("bT*"),f7:s("bu*"),Z:s("aw*"),dC:s("dg*"),F:s("C*"),e:s("f*"),eH:s("aB<m>?"),O:s("e?"),di:s("Q"),H:s("~"),d5:s("~(e)"),da:s("~(e,aU)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.ab=A.dG.prototype
B.ac=A.fa.prototype
B.bQ=J.dM.prototype
B.d=J.E.prototype
B.bV=J.dO.prototype
B.c=J.dP.prototype
B.C=J.cs.prototype
B.a=J.bK.prototype
B.bW=J.bn.prototype
B.bX=J.aC.prototype
B.j=A.cL.prototype
B.aA=J.fF.prototype
B.W=J.bU.prototype
B.X=new A.B("MAT4",5126,!1)
B.H=new A.B("SCALAR",5126,!1)
B.Z=new A.B("VEC2",5120,!0)
B.a_=new A.B("VEC2",5121,!0)
B.a1=new A.B("VEC2",5122,!0)
B.a2=new A.B("VEC2",5123,!0)
B.a3=new A.B("VEC2",5126,!1)
B.w=new A.B("VEC3",5120,!0)
B.I=new A.B("VEC3",5121,!0)
B.x=new A.B("VEC3",5122,!0)
B.J=new A.B("VEC3",5123,!0)
B.k=new A.B("VEC3",5126,!1)
B.K=new A.B("VEC4",5120,!0)
B.aZ=new A.B("VEC4",5121,!1)
B.y=new A.B("VEC4",5121,!0)
B.L=new A.B("VEC4",5122,!0)
B.b_=new A.B("VEC4",5123,!1)
B.z=new A.B("VEC4",5123,!0)
B.n=new A.B("VEC4",5126,!1)
B.b0=new A.cb("AnimationInput")
B.b1=new A.cb("AnimationOutput")
B.b2=new A.cb("IBM")
B.b3=new A.cb("PrimitiveIndices")
B.a6=new A.cb("VertexAttribute")
B.b4=new A.ce("IBM")
B.b5=new A.ce("Image")
B.M=new A.ce("IndexBuffer")
B.o=new A.ce("Other")
B.A=new A.ce("VertexBuffer")
B.ec=new A.hS()
B.b6=new A.hQ()
B.b7=new A.hR()
B.b8=new A.dE(A.aM("dE<0&*>"))
B.b9=new A.cr()
B.a7=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.ba=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.bf=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.bb=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.bc=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.be=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.bd=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.a8=function(hooks) { return hooks; }

B.bg=new A.jx()
B.bh=new A.fE()
B.bi=new A.eb()
B.bj=new A.ec()
B.N=new A.mh()
B.a9=new A.mG()
B.aa=new A.n9()
B.i=new A.na()
B.bk=new A.hm()
B.P=new A.co(0,"Unknown")
B.p=new A.co(1,"RGB")
B.B=new A.co(2,"RGBA")
B.ad=new A.co(3,"Luminance")
B.ae=new A.co(4,"LuminanceAlpha")
B.af=new A.d5(0,"JPEG")
B.ag=new A.d5(1,"PNG")
B.ah=new A.d5(2,"WebP")
B.bP=new A.d5(3,"KTX2")
B.ai=new A.aO("Wrong WebP header.")
B.bR=new A.aO("PNG header not found.")
B.bS=new A.aO("Invalid JPEG marker segment length.")
B.q=new A.aO("Wrong chunk length.")
B.bT=new A.aO("Invalid number of JPEG color channels.")
B.bU=new A.aO("Invalid start of file.")
B.bY=new A.jy(null)
B.bZ=A.a(s([0,0]),t.o)
B.aj=A.a(s([0,0,0]),t.o)
B.c_=A.a(s([16]),t.V)
B.c0=A.a(s([1,1]),t.o)
B.D=A.a(s([1,1,1]),t.o)
B.ak=A.a(s([1,1,1,1]),t.o)
B.al=A.a(s([2]),t.V)
B.c2=A.a(s(["sheenColorFactor","sheenColorTexture","sheenRoughnessFactor","sheenRoughnessTexture"]),t.i)
B.am=A.a(s([0,0,32776,33792,1,10240,0,0]),t.V)
B.c3=A.a(s(["clearcoatFactor","clearcoatTexture","clearcoatRoughnessFactor","clearcoatRoughnessTexture","clearcoatNormalTexture"]),t.i)
B.l=A.a(s([3]),t.V)
B.an=A.a(s([33071,33648,10497]),t.V)
B.c4=A.a(s([34962,34963]),t.V)
B.c5=A.a(s(["specularFactor","specularTexture","specularColorFactor","specularColorTexture"]),t.i)
B.Q=A.a(s([4]),t.V)
B.Y=new A.B("VEC2",5120,!1)
B.aV=new A.B("VEC2",5121,!1)
B.a0=new A.B("VEC2",5122,!1)
B.aW=new A.B("VEC2",5123,!1)
B.c6=A.a(s([B.Y,B.Z,B.aV,B.a0,B.a1,B.aW]),t.p)
B.c7=A.a(s([5121,5123,5125]),t.V)
B.ao=A.a(s(["image/jpeg","image/png"]),t.i)
B.c8=A.a(s(["transmissionFactor","transmissionTexture"]),t.i)
B.c9=A.a(s([9728,9729]),t.V)
B.aP=new A.B("SCALAR",5121,!1)
B.aS=new A.B("SCALAR",5123,!1)
B.aU=new A.B("SCALAR",5125,!1)
B.ap=A.a(s([B.aP,B.aS,B.aU]),t.p)
B.cb=A.a(s(["image/jpeg","image/png","image/webp","image/ktx2"]),t.i)
B.cc=A.a(s(["camera","children","skin","matrix","mesh","rotation","scale","translation","weights","name"]),t.i)
B.cd=A.a(s([9728,9729,9984,9985,9986,9987]),t.V)
B.ce=A.a(s(["COLOR","JOINTS","TEXCOORD","WEIGHTS"]),t.i)
B.E=A.a(s([0,0,65490,45055,65535,34815,65534,18431]),t.V)
B.cf=A.a(s(["color","intensity","spot","type","range","name"]),t.i)
B.cg=A.a(s(["buffer","byteOffset","byteLength","byteStride","target","name"]),t.i)
B.ar=A.a(s([0,0,26624,1023,65534,2047,65534,2047]),t.V)
B.ch=A.a(s(["LINEAR","STEP","CUBICSPLINE"]),t.i)
B.V=A.x("bT")
B.bl=new A.Z(A.xZ(),!1,!1)
B.dv=new A.a5([B.V,B.bl],t.N)
B.bC=new A.U("EXT_texture_webp",B.dv,A.y_(),!1)
B.T=A.x("dJ")
B.U=A.x("at")
B.bm=new A.Z(A.yf(),!1,!1)
B.bn=new A.Z(A.yh(),!1,!1)
B.dt=new A.a5([B.T,B.bm,B.U,B.bn],t.N)
B.bK=new A.U("KHR_lights_punctual",B.dt,null,!1)
B.f=A.x("aE")
B.bp=new A.Z(A.yi(),!1,!1)
B.dh=new A.a5([B.f,B.bp],t.N)
B.bH=new A.U("KHR_materials_clearcoat",B.dh,null,!1)
B.bq=new A.Z(A.yj(),!1,!1)
B.di=new A.a5([B.f,B.bq],t.N)
B.bN=new A.U("KHR_materials_emissive_strength",B.di,null,!1)
B.br=new A.Z(A.yk(),!1,!1)
B.dj=new A.a5([B.f,B.br],t.N)
B.bL=new A.U("KHR_materials_ior",B.dj,null,!1)
B.bs=new A.Z(A.yl(),!1,!1)
B.dk=new A.a5([B.f,B.bs],t.N)
B.bG=new A.U("KHR_materials_iridescence",B.dk,null,!1)
B.by=new A.Z(A.ym(),!0,!1)
B.dl=new A.a5([B.f,B.by],t.N)
B.bE=new A.U("KHR_materials_pbrSpecularGlossiness",B.dl,null,!1)
B.bt=new A.Z(A.yn(),!1,!1)
B.dm=new A.a5([B.f,B.bt],t.N)
B.bB=new A.U("KHR_materials_sheen",B.dm,null,!1)
B.bu=new A.Z(A.yo(),!1,!1)
B.dn=new A.a5([B.f,B.bu],t.N)
B.bJ=new A.U("KHR_materials_specular",B.dn,null,!1)
B.bv=new A.Z(A.yp(),!1,!1)
B.dp=new A.a5([B.f,B.bv],t.N)
B.bI=new A.U("KHR_materials_transmission",B.dp,null,!1)
B.bz=new A.Z(A.yq(),!0,!1)
B.dq=new A.a5([B.f,B.bz],t.N)
B.bA=new A.U("KHR_materials_unlit",B.dq,null,!1)
B.aE=A.x("aJ")
B.bw=new A.Z(A.vm(),!1,!1)
B.bx=new A.Z(A.vn(),!1,!0)
B.ds=new A.a5([B.T,B.bw,B.aE,B.bx],t.N)
B.bF=new A.U("KHR_materials_variants",B.ds,null,!1)
B.bo=new A.Z(A.yr(),!1,!1)
B.dr=new A.a5([B.f,B.bo],t.N)
B.bM=new A.U("KHR_materials_volume",B.dr,null,!1)
B.cB=A.a(s([]),A.aM("E<bu*>"))
B.dw=new A.aA(0,{},B.cB,A.aM("aA<bu*,Z*>"))
B.bO=new A.U("KHR_mesh_quantization",B.dw,A.ys(),!0)
B.aK=A.x("bt")
B.aG=A.x("cM")
B.aH=A.x("cN")
B.O=new A.Z(A.yt(),!1,!1)
B.du=new A.a5([B.aK,B.O,B.aG,B.O,B.aH,B.O],t.N)
B.bD=new A.U("KHR_texture_transform",B.du,null,!1)
B.as=A.a(s([B.bC,B.bK,B.bH,B.bN,B.bL,B.bG,B.bE,B.bB,B.bJ,B.bI,B.bA,B.bF,B.bM,B.bO,B.bD]),A.aM("E<U*>"))
B.ci=A.a(s(["OPAQUE","MASK","BLEND"]),t.i)
B.cj=A.a(s(["pbrMetallicRoughness","normalTexture","occlusionTexture","emissiveTexture","emissiveFactor","alphaMode","alphaCutoff","doubleSided","name"]),t.i)
B.ck=A.a(s([5120,5121,5122,5123,5125,5126]),t.V)
B.cl=A.a(s(["inverseBindMatrices","skeleton","joints","name"]),t.i)
B.a4=new A.B("VEC3",5120,!1)
B.a5=new A.B("VEC3",5122,!1)
B.cm=A.a(s([B.a4,B.w,B.a5,B.x]),t.p)
B.cn=A.a(s(["data-uri","buffer-view","glb","external"]),t.i)
B.co=A.a(s(["POINTS","LINES","LINE_LOOP","LINE_STRIP","TRIANGLES","TRIANGLE_STRIP","TRIANGLE_FAN"]),t.i)
B.cp=A.a(s(["bufferView","byteOffset","componentType"]),t.i)
B.R=A.a(s([B.w,B.x]),t.p)
B.cq=A.a(s(["aspectRatio","yfov","zfar","znear"]),t.i)
B.cr=A.a(s(["copyright","generator","version","minVersion"]),t.i)
B.cs=A.a(s(["bufferView","byteOffset"]),t.i)
B.ct=A.a(s(["bufferView","mimeType","uri","name"]),t.i)
B.cu=A.a(s(["channels","samplers","name"]),t.i)
B.cv=A.a(s(["baseColorFactor","baseColorTexture","metallicFactor","roughnessFactor","metallicRoughnessTexture"]),t.i)
B.cw=A.a(s(["count","indices","values"]),t.i)
B.cx=A.a(s(["diffuseFactor","diffuseTexture","specularFactor","glossinessFactor","specularGlossinessTexture"]),t.i)
B.cy=A.a(s(["directional","point","spot"]),t.i)
B.cz=A.a(s(["emissiveStrength"]),t.i)
B.at=A.a(s([]),t.b)
B.cA=A.a(s([]),t.i)
B.cD=A.a(s(["extensions","extras"]),t.i)
B.cE=A.a(s([0,0,32722,12287,65534,34815,65534,18431]),t.V)
B.cG=A.a(s(["index","texCoord"]),t.i)
B.cH=A.a(s(["index","texCoord","scale"]),t.i)
B.cI=A.a(s(["index","texCoord","strength"]),t.i)
B.cJ=A.a(s(["innerConeAngle","outerConeAngle"]),t.i)
B.cK=A.a(s(["input","interpolation","output"]),t.i)
B.cL=A.a(s(["ior"]),t.i)
B.cM=A.a(s(["attributes","indices","material","mode","targets"]),t.i)
B.cN=A.a(s(["bufferView","byteOffset","componentType","count","type","normalized","max","min","sparse","name"]),t.i)
B.cO=A.a(s(["light"]),t.i)
B.cP=A.a(s(["lights"]),t.i)
B.cQ=A.a(s(["mappings"]),t.i)
B.cR=A.a(s(["name"]),t.i)
B.cS=A.a(s(["node","path"]),t.i)
B.cT=A.a(s(["nodes","name"]),t.i)
B.cU=A.a(s([null,"linear","srgb","custom"]),t.i)
B.cV=A.a(s([null,"srgb","custom"]),t.i)
B.au=A.a(s([0,0,24576,1023,65534,34815,65534,18431]),t.V)
B.cW=A.a(s(["image/webp"]),t.i)
B.cX=A.a(s(["offset","rotation","scale","texCoord"]),t.i)
B.av=A.a(s(["orthographic","perspective"]),t.i)
B.cY=A.a(s(["primitives","weights","name"]),t.i)
B.cZ=A.a(s([0,0,32754,11263,65534,34815,65534,18431]),t.V)
B.d_=A.a(s(["magFilter","minFilter","wrapS","wrapT","name"]),t.i)
B.d0=A.a(s([null,"rgb","rgba","luminance","luminance-alpha"]),t.i)
B.aw=A.a(s([0,0,65490,12287,65535,34815,65534,18431]),t.V)
B.d2=A.a(s(["sampler","source","name"]),t.i)
B.d3=A.a(s(["source"]),t.i)
B.d4=A.a(s(["iridescenceFactor","iridescenceTexture","iridescenceIor","iridescenceThicknessMinimum","iridescenceThicknessMaximum","iridescenceThicknessTexture"]),t.i)
B.aX=new A.B("VEC3",5121,!1)
B.aY=new A.B("VEC3",5123,!1)
B.d5=A.a(s([B.a4,B.w,B.aX,B.I,B.a5,B.x,B.aY,B.J]),t.p)
B.d6=A.a(s(["target","sampler"]),t.i)
B.ax=A.a(s(["translation","rotation","scale","weights"]),t.i)
B.d7=A.a(s(["type","orthographic","perspective","name"]),t.i)
B.d8=A.a(s(["uri","byteLength","name"]),t.i)
B.d9=A.a(s(["variants"]),t.i)
B.da=A.a(s(["variants","material","name"]),t.i)
B.db=A.a(s([B.Y,B.a0]),t.p)
B.dc=A.a(s(["attenuationColor","attenuationDistance","thicknessFactor","thicknessTexture"]),t.i)
B.dd=A.a(s(["xmag","ymag","zfar","znear"]),t.i)
B.de=A.a(s(["extensionsUsed","extensionsRequired","accessors","animations","asset","buffers","bufferViews","cameras","images","materials","meshes","nodes","samplers","scene","scenes","skins","textures"]),t.i)
B.df=A.a(s([B.K,B.L]),t.p)
B.aq=A.a(s([B.k]),t.p)
B.c1=A.a(s([B.n,B.y,B.K,B.z,B.L]),t.p)
B.aQ=new A.B("SCALAR",5121,!0)
B.aO=new A.B("SCALAR",5120,!0)
B.aT=new A.B("SCALAR",5123,!0)
B.aR=new A.B("SCALAR",5122,!0)
B.cF=A.a(s([B.H,B.aQ,B.aO,B.aT,B.aR]),t.p)
B.dg=new A.aA(4,{translation:B.aq,rotation:B.c1,scale:B.aq,weights:B.cF},B.ax,A.aM("aA<d*,q<B*>*>"))
B.ca=A.a(s(["SCALAR","VEC2","VEC3","VEC4","MAT2","MAT3","MAT4"]),t.i)
B.m=new A.aA(7,{SCALAR:1,VEC2:2,VEC3:3,VEC4:4,MAT2:4,MAT3:9,MAT4:16},B.ca,A.aM("aA<d*,f*>"))
B.ay=new A.a5([5120,"BYTE",5121,"UNSIGNED_BYTE",5122,"SHORT",5123,"UNSIGNED_SHORT",5124,"INT",5125,"UNSIGNED_INT",5126,"FLOAT",35664,"FLOAT_VEC2",35665,"FLOAT_VEC3",35666,"FLOAT_VEC4",35667,"INT_VEC2",35668,"INT_VEC3",35669,"INT_VEC4",35670,"BOOL",35671,"BOOL_VEC2",35672,"BOOL_VEC3",35673,"BOOL_VEC4",35674,"FLOAT_MAT2",35675,"FLOAT_MAT3",35676,"FLOAT_MAT4",35678,"SAMPLER_2D"],A.aM("a5<f*,d*>"))
B.cC=A.a(s([]),A.aM("E<cQ*>"))
B.az=new A.aA(0,{},B.cC,A.aM("aA<cQ*,@>"))
B.d1=A.a(s(["KHR","EXT","ADOBE","AGI","AGT","ALCM","ALI","AMZN","ANIMECH","ASOBO","AVR","BLENDER","CAPTURE","CESIUM","CITRUS","CLO","CVTOOLS","EMBARK","EPIC","F8","FB","FOXIT","GOOGLE","GRIFFEL","INTEL","KDAB","LLQ","MAXAR","MESHOPT","MOZ","MPEG","MSFT","MTTR","MX","NEEDLE","NV","OFT","OMI","OTOY","OWLII","PANDA3D","POLUTROPON","PTC","S8S","SE","SEIN","SHAPEDIVER","SI","SKFB","SKYLINE","SNAP","SPECTRUM","TENCENT","TRYON","UX3D","VRMC","WEB3D"]),t.i)
B.dx=new A.aA(57,{KHR:null,EXT:null,ADOBE:null,AGI:null,AGT:null,ALCM:null,ALI:null,AMZN:null,ANIMECH:null,ASOBO:null,AVR:null,BLENDER:null,CAPTURE:null,CESIUM:null,CITRUS:null,CLO:null,CVTOOLS:null,EMBARK:null,EPIC:null,F8:null,FB:null,FOXIT:null,GOOGLE:null,GRIFFEL:null,INTEL:null,KDAB:null,LLQ:null,MAXAR:null,MESHOPT:null,MOZ:null,MPEG:null,MSFT:null,MTTR:null,MX:null,NEEDLE:null,NV:null,OFT:null,OMI:null,OTOY:null,OWLII:null,PANDA3D:null,POLUTROPON:null,PTC:null,S8S:null,SE:null,SEIN:null,SHAPEDIVER:null,SI:null,SKFB:null,SKYLINE:null,SNAP:null,SPECTRUM:null,TENCENT:null,TRYON:null,UX3D:null,VRMC:null,WEB3D:null},B.d1,A.aM("aA<d*,m>"))
B.dy=new A.eD(B.dx,A.aM("eD<d*>"))
B.b=new A.dd(0,"Error")
B.e=new A.dd(1,"Warning")
B.h=new A.dd(2,"Information")
B.dz=new A.dd(3,"Hint")
B.dA=new A.de("call")
B.dB=A.x("c9")
B.dC=A.x("ca")
B.dD=A.x("c8")
B.S=A.x("ad<Q>")
B.dE=A.x("cc")
B.dF=A.x("bd")
B.dG=A.x("be")
B.aB=A.x("bF")
B.dH=A.x("bG")
B.aC=A.x("bH")
B.dI=A.x("b_")
B.dJ=A.x("cf")
B.dK=A.x("cg")
B.dL=A.x("bI")
B.dM=A.x("cA")
B.dN=A.x("cm")
B.aD=A.x("b1")
B.dO=A.x("bL")
B.dP=A.x("cu")
B.dQ=A.x("bp")
B.dR=A.x("cv")
B.dS=A.x("cw")
B.dT=A.x("cx")
B.dU=A.x("cy")
B.dV=A.x("cz")
B.dW=A.x("cB")
B.dX=A.x("cC")
B.dY=A.x("cD")
B.dZ=A.x("cE")
B.e_=A.x("bM")
B.e0=A.x("bq")
B.e1=A.x("aP")
B.e2=A.x("cG")
B.e3=A.x("cH")
B.aF=A.x("b2")
B.e4=A.x("e")
B.e5=A.x("cO")
B.e6=A.x("bO")
B.aI=A.x("bP")
B.aJ=A.x("bQ")
B.e7=A.x("cF")
B.e8=new A.mi(!1)
B.r=new A.eg(0,"Unknown")
B.t=new A.eg(1,"sRGB")
B.F=new A.eg(2,"Custom")
B.u=new A.di(0,"Unknown")
B.e9=new A.di(1,"Linear")
B.v=new A.di(2,"sRGB")
B.G=new A.di(3,"Custom")
B.ea=new A.dl(null,2)
B.aL=new A.dp(0,"DataUri")
B.aM=new A.dp(1,"BufferView")
B.eb=new A.dp(2,"GLB")
B.aN=new A.dp(3,"External")})();(function staticFields(){$.mY=null
$.pZ=null
$.kU=0
$.e3=A.xm()
$.pC=null
$.pB=null
$.r1=null
$.qS=null
$.r9=null
$.nN=null
$.nY=null
$.oT=null
$.du=null
$.eJ=null
$.eK=null
$.oN=!1
$.F=B.i
$.cW=A.a([],A.aM("E<e>"))
$.pU=null
$.pS=null
$.pT=null})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy,q=hunkHelpers.lazyOld
s($,"yV","ob",()=>A.r_("_$dart_dartClosure"))
s($,"Cv","oi",()=>B.i.dc(new A.o6()))
s($,"BI","uh",()=>A.bv(A.mb({
toString:function(){return"$receiver$"}})))
s($,"BJ","ui",()=>A.bv(A.mb({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"BK","uj",()=>A.bv(A.mb(null)))
s($,"BL","uk",()=>A.bv(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(p){return p.message}}()))
s($,"BO","un",()=>A.bv(A.mb(void 0)))
s($,"BP","uo",()=>A.bv(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(p){return p.message}}()))
s($,"BN","um",()=>A.bv(A.qa(null)))
s($,"BM","ul",()=>A.bv(function(){try{null.$method$}catch(p){return p.message}}()))
s($,"BR","uq",()=>A.bv(A.qa(void 0)))
s($,"BQ","up",()=>A.bv(function(){try{(void 0).$method$}catch(p){return p.message}}()))
s($,"BU","pj",()=>A.wd())
s($,"zv","hF",()=>$.oi())
s($,"BS","ur",()=>new A.mk().$0())
s($,"BT","us",()=>new A.mj().$0())
s($,"BW","pk",()=>A.vM(A.x4(A.a([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.Y))))
r($,"BV","ut",()=>A.vN(0))
s($,"Ci","uv",()=>A.o7(B.e4))
s($,"BF","pi",()=>{A.vW()
return $.kU})
s($,"Cp","uA",()=>A.x1())
s($,"yU","rg",()=>A.ox("^\\S+$"))
s($,"Cd","uu",()=>A.qQ(self))
s($,"BX","pl",()=>A.r_("_$dart_dartObject"))
s($,"Ce","pm",()=>function DartObject(a){this.o=a})
q($,"yP","bC",()=>A.ox("^([0-9]+)\\.([0-9]+)$"))
q($,"yT","rf",()=>A.ox("^([A-Z0-9]+)_[A-Za-z0-9_]+$"))
q($,"zh","ry",()=>A.K("BUFFER_BYTE_LENGTH_MISMATCH",new A.iw(),B.b))
q($,"zi","rz",()=>A.K("BUFFER_GLB_CHUNK_TOO_BIG",new A.ix(),B.e))
q($,"za","oZ",()=>A.K("ACCESSOR_MIN_MISMATCH",new A.ip(),B.b))
q($,"z9","oY",()=>A.K("ACCESSOR_MAX_MISMATCH",new A.io(),B.b))
q($,"z_","oX",()=>A.K("ACCESSOR_ELEMENT_OUT_OF_MIN_BOUND",new A.ic(),B.b))
q($,"yZ","oW",()=>A.K("ACCESSOR_ELEMENT_OUT_OF_MAX_BOUND",new A.ib(),B.b))
q($,"ze","p_",()=>A.K("ACCESSOR_VECTOR3_NON_UNIT",new A.it(),B.b))
q($,"z5","rp",()=>A.K("ACCESSOR_INVALID_SIGN",new A.ij(),B.b))
q($,"yY","rj",()=>A.K("ACCESSOR_ANIMATION_SAMPLER_OUTPUT_NON_NORMALIZED_QUATERNION",new A.ia(),B.b))
q($,"zb","rt",()=>A.K("ACCESSOR_NON_CLAMPED",new A.iq(),B.b))
q($,"z3","rn",()=>A.K("ACCESSOR_INVALID_FLOAT",new A.ih(),B.b))
q($,"z0","rk",()=>A.K("ACCESSOR_INDEX_OOB",new A.id(),B.b))
q($,"z2","rm",()=>A.K("ACCESSOR_INDEX_TRIANGLE_DEGENERATE",new A.ig(),B.h))
q($,"z1","rl",()=>A.K("ACCESSOR_INDEX_PRIMITIVE_RESTART",new A.ie(),B.b))
q($,"yW","rh",()=>A.K("ACCESSOR_ANIMATION_INPUT_NEGATIVE",new A.i8(),B.b))
q($,"yX","ri",()=>A.K("ACCESSOR_ANIMATION_INPUT_NON_INCREASING",new A.i9(),B.b))
q($,"zd","rv",()=>A.K("ACCESSOR_SPARSE_INDICES_NON_INCREASING",new A.is(),B.b))
q($,"zc","ru",()=>A.K("ACCESSOR_SPARSE_INDEX_OOB",new A.ir(),B.b))
q($,"z4","ro",()=>A.K("ACCESSOR_INVALID_IBM",new A.ii(),B.b))
q($,"zk","rA",()=>A.K("IMAGE_DATA_INVALID",new A.iz(),B.b))
q($,"zm","rC",()=>A.K("IMAGE_MIME_TYPE_INVALID",new A.iB(),B.b))
q($,"zp","rF",()=>A.K("IMAGE_UNEXPECTED_EOS",new A.iE(),B.b))
q($,"zq","rG",()=>A.K("IMAGE_UNRECOGNIZED_FORMAT",new A.iF(),B.e))
q($,"zn","rD",()=>A.K("IMAGE_NON_ENABLED_MIME_TYPE",new A.iC(),B.b))
q($,"zo","rE",()=>A.K("IMAGE_NPOT_DIMENSIONS",new A.iD(),B.h))
q($,"zl","rB",()=>A.K("IMAGE_FEATURES_UNSUPPORTED",new A.iA(),B.e))
q($,"zr","p1",()=>A.K("URI_GLB",new A.iG(),B.h))
q($,"zj","p0",()=>A.K("DATA_URI_GLB",new A.iy(),B.e))
q($,"z7","rr",()=>A.K("ACCESSOR_JOINTS_INDEX_OOB",new A.il(),B.b))
q($,"z6","rq",()=>A.K("ACCESSOR_JOINTS_INDEX_DUPLICATE",new A.ik(),B.b))
q($,"zf","rw",()=>A.K("ACCESSOR_WEIGHTS_NEGATIVE",new A.iu(),B.b))
q($,"zg","rx",()=>A.K("ACCESSOR_WEIGHTS_NON_NORMALIZED",new A.iv(),B.b))
q($,"z8","rs",()=>A.K("ACCESSOR_JOINTS_USED_ZERO_WEIGHT",new A.im(),B.e))
q($,"zO","oc",()=>new A.jl(B.b,"IO_ERROR",new A.jm()))
q($,"AE","pb",()=>A.ar("ARRAY_LENGTH_NOT_IN_LIST",new A.l0(),B.b))
q($,"AF","eR",()=>A.ar("ARRAY_TYPE_MISMATCH",new A.l1(),B.b))
q($,"AD","pa",()=>A.ar("DUPLICATE_ELEMENTS",new A.l_(),B.b))
q($,"AH","hH",()=>A.ar("INVALID_INDEX",new A.l3(),B.b))
q($,"AI","od",()=>A.ar("INVALID_JSON",new A.l4(),B.b))
q($,"AJ","pc",()=>A.ar("INVALID_URI",new A.l5(),B.b))
q($,"AG","c7",()=>A.ar("EMPTY_ENTITY",new A.l2(),B.b))
q($,"AK","pd",()=>A.ar("ONE_OF_MISMATCH",new A.l6(),B.b))
q($,"AL","ty",()=>A.ar("PATTERN_MISMATCH",new A.l7(),B.b))
q($,"AM","ac",()=>A.ar("TYPE_MISMATCH",new A.l8(),B.b))
q($,"AR","tB",()=>A.ar("VALUE_NOT_IN_LIST",new A.ld(),B.e))
q($,"AS","oe",()=>A.ar("VALUE_NOT_IN_RANGE",new A.le(),B.b))
q($,"AQ","tA",()=>A.ar("VALUE_MULTIPLE_OF",new A.lc(),B.b))
q($,"AN","bD",()=>A.ar("UNDEFINED_PROPERTY",new A.l9(),B.b))
q($,"AO","tz",()=>A.ar("UNEXPECTED_PROPERTY",new A.la(),B.e))
q($,"AP","d_",()=>A.ar("UNSATISFIED_DEPENDENCY",new A.lb(),B.b))
q($,"BB","ud",()=>A.v("UNKNOWN_ASSET_MAJOR_VERSION",new A.lZ(),B.b))
q($,"BC","ue",()=>A.v("UNKNOWN_ASSET_MINOR_VERSION",new A.m_(),B.e))
q($,"Bm","u_",()=>A.v("ASSET_MIN_VERSION_GREATER_THAN_VERSION",new A.lK(),B.b))
q($,"B6","tL",()=>A.v("INVALID_GL_VALUE",new A.lu(),B.b))
q($,"AU","tD",()=>A.v("ACCESSOR_NORMALIZED_INVALID",new A.lh(),B.b))
q($,"AV","tE",()=>A.v("ACCESSOR_OFFSET_ALIGNMENT",new A.li(),B.b))
q($,"AT","tC",()=>A.v("ACCESSOR_MATRIX_ALIGNMENT",new A.lg(),B.b))
q($,"AW","tF",()=>A.v("ACCESSOR_SPARSE_COUNT_OUT_OF_RANGE",new A.lj(),B.b))
q($,"AX","tG",()=>A.v("ANIMATION_CHANNEL_TARGET_NODE_SKIN",new A.lk(),B.e))
q($,"AY","tH",()=>A.v("BUFFER_DATA_URI_MIME_TYPE_INVALID",new A.ll(),B.b))
q($,"B_","tI",()=>A.v("BUFFER_VIEW_TOO_BIG_BYTE_STRIDE",new A.ln(),B.b))
q($,"AZ","of",()=>A.v("BUFFER_VIEW_INVALID_BYTE_STRIDE",new A.lm(),B.b))
q($,"B0","pe",()=>A.v("CAMERA_XMAG_YMAG_NEGATIVE",new A.lo(),B.e))
q($,"B1","pf",()=>A.v("CAMERA_XMAG_YMAG_ZERO",new A.lp(),B.b))
q($,"B2","tJ",()=>A.v("CAMERA_YFOV_GEQUAL_PI",new A.lq(),B.e))
q($,"B3","pg",()=>A.v("CAMERA_ZFAR_LEQUAL_ZNEAR",new A.lr(),B.b))
q($,"Be","tT",()=>A.v("MATERIAL_ALPHA_CUTOFF_INVALID_MODE",new A.lC(),B.e))
q($,"Bh","og",()=>A.v("MESH_PRIMITIVE_INVALID_ATTRIBUTE",new A.lF(),B.b))
q($,"Bl","tZ",()=>A.v("MESH_PRIMITIVES_UNEQUAL_TARGETS_COUNT",new A.lJ(),B.b))
q($,"Bj","tX",()=>A.v("MESH_PRIMITIVE_NO_POSITION",new A.lH(),B.e))
q($,"Bg","tV",()=>A.v("MESH_PRIMITIVE_INDEXED_SEMANTIC_CONTINUITY",new A.lE(),B.b))
q($,"Bk","tY",()=>A.v("MESH_PRIMITIVE_TANGENT_WITHOUT_NORMAL",new A.lI(),B.e))
q($,"Bi","tW",()=>A.v("MESH_PRIMITIVE_JOINTS_WEIGHTS_MISMATCH",new A.lG(),B.b))
q($,"Bf","tU",()=>A.v("MESH_INVALID_WEIGHTS_COUNT",new A.lD(),B.b))
q($,"Bq","u3",()=>A.v("NODE_MATRIX_TRS",new A.lO(),B.b))
q($,"Bo","u1",()=>A.v("NODE_MATRIX_DEFAULT",new A.lM(),B.h))
q($,"Br","u4",()=>A.v("NODE_MATRIX_NON_TRS",new A.lP(),B.b))
q($,"By","ua",()=>A.v("ROTATION_NON_UNIT",new A.lW(),B.b))
q($,"BE","ug",()=>A.v("UNUSED_EXTENSION_REQUIRED",new A.m1(),B.b))
q($,"Bx","u9",()=>A.v("NON_REQUIRED_EXTENSION",new A.lV(),B.b))
q($,"BD","uf",()=>A.v("UNRESERVED_EXTENSION_PREFIX",new A.m0(),B.e))
q($,"B5","tK",()=>A.v("INVALID_EXTENSION_NAME_FORMAT",new A.lt(),B.e))
q($,"Bp","u2",()=>A.v("NODE_EMPTY",new A.lN(),B.h))
q($,"Bu","u7",()=>A.v("NODE_SKINNED_MESH_NON_ROOT",new A.lS(),B.e))
q($,"Bt","u6",()=>A.v("NODE_SKINNED_MESH_LOCAL_TRANSFORMS",new A.lR(),B.e))
q($,"Bs","u5",()=>A.v("NODE_SKIN_NO_SCENE",new A.lQ(),B.b))
q($,"Bz","ub",()=>A.v("SKIN_NO_COMMON_ROOT",new A.lX(),B.b))
q($,"BA","uc",()=>A.v("SKIN_SKELETON_INVALID",new A.lY(),B.b))
q($,"Bw","u8",()=>A.v("NON_RELATIVE_URI",new A.lU(),B.e))
q($,"Bn","u0",()=>A.v("MULTIPLE_EXTENSIONS",new A.lL(),B.e))
q($,"Bv","dy",()=>A.v("NON_OBJECT_EXTRAS",new A.lT(),B.h))
q($,"B4","ph",()=>A.v("EXTRA_PROPERTY",new A.ls(),B.h))
q($,"B7","tM",()=>A.v("KHR_LIGHTS_PUNCTUAL_LIGHT_SPOT_ANGLES",new A.lv(),B.b))
q($,"B8","tN",()=>A.v("KHR_MATERIALS_EMISSIVE_STRENGTH_ZERO_FACTOR",new A.lw(),B.e))
q($,"Bd","tS",()=>A.v("KHR_MATERIALS_VOLUME_NO_TRANSMISSION",new A.lB(),B.e))
q($,"Bc","tR",()=>A.v("KHR_MATERIALS_VOLUME_DOUBLE_SIDED",new A.lA(),B.e))
q($,"Ba","tP",()=>A.v("KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_WITHOUT_TEXTURE",new A.ly(),B.h))
q($,"B9","tO",()=>A.v("KHR_MATERIALS_IRIDESCENCE_THICKNESS_RANGE_INVALID",new A.lx(),B.b))
q($,"Bb","tQ",()=>A.v("KHR_MATERIALS_IRIDESCENCE_THICKNESS_TEXTURE_UNUSED",new A.lz(),B.h))
q($,"zR","rY",()=>A.y("ACCESSOR_TOTAL_OFFSET_ALIGNMENT",new A.jI(),B.b))
q($,"zP","rX",()=>A.y("ACCESSOR_SMALL_BYTESTRIDE",new A.jG(),B.b))
q($,"zQ","p2",()=>A.y("ACCESSOR_TOO_LONG",new A.jH(),B.b))
q($,"zS","rZ",()=>A.y("ACCESSOR_USAGE_OVERRIDE",new A.jJ(),B.b))
q($,"zV","t1",()=>A.y("ANIMATION_DUPLICATE_TARGETS",new A.jM(),B.b))
q($,"zT","t_",()=>A.y("ANIMATION_CHANNEL_TARGET_NODE_MATRIX",new A.jK(),B.b))
q($,"zU","t0",()=>A.y("ANIMATION_CHANNEL_TARGET_NODE_WEIGHTS_NO_MORPHS",new A.jL(),B.b))
q($,"zZ","t4",()=>A.y("ANIMATION_SAMPLER_INPUT_ACCESSOR_WITHOUT_BOUNDS",new A.jQ(),B.b))
q($,"zX","t2",()=>A.y("ANIMATION_SAMPLER_INPUT_ACCESSOR_INVALID_FORMAT",new A.jO(),B.b))
q($,"A0","t6",()=>A.y("ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_FORMAT",new A.jS(),B.b))
q($,"zY","t3",()=>A.y("ANIMATION_SAMPLER_INPUT_ACCESSOR_TOO_FEW_ELEMENTS",new A.jP(),B.b))
q($,"A_","t5",()=>A.y("ANIMATION_SAMPLER_OUTPUT_ACCESSOR_INVALID_COUNT",new A.jR(),B.b))
q($,"zW","p3",()=>A.y("ANIMATION_SAMPLER_ACCESSOR_WITH_BYTESTRIDE",new A.jN(),B.b))
q($,"A1","t7",()=>A.y("BUFFER_MISSING_GLB_DATA",new A.jT(),B.b))
q($,"A4","p4",()=>A.y("BUFFER_VIEW_TOO_LONG",new A.jW(),B.b))
q($,"A3","t9",()=>A.y("BUFFER_VIEW_TARGET_OVERRIDE",new A.jV(),B.b))
q($,"A2","t8",()=>A.y("BUFFER_VIEW_TARGET_MISSING",new A.jU(),B.dz))
q($,"A5","ta",()=>A.y("IMAGE_BUFFER_VIEW_WITH_BYTESTRIDE",new A.jX(),B.b))
q($,"A6","tb",()=>A.y("INVALID_IBM_ACCESSOR_COUNT",new A.jY(),B.b))
q($,"Aa","p6",()=>A.y("MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_INVALID_FORMAT",new A.k1(),B.b))
q($,"Ab","te",()=>A.y("MESH_PRIMITIVE_ATTRIBUTES_ACCESSOR_UNSIGNED_INT",new A.k2(),B.b))
q($,"Ah","p7",()=>A.y("MESH_PRIMITIVE_POSITION_ACCESSOR_WITHOUT_BOUNDS",new A.k8(),B.b))
q($,"A9","td",()=>A.y("MESH_PRIMITIVE_ACCESSOR_WITHOUT_BYTESTRIDE",new A.k0(),B.b))
q($,"A8","p5",()=>A.y("MESH_PRIMITIVE_ACCESSOR_UNALIGNED",new A.k_(),B.b))
q($,"Ae","th",()=>A.y("MESH_PRIMITIVE_INDICES_ACCESSOR_WITH_BYTESTRIDE",new A.k5(),B.b))
q($,"Ad","tg",()=>A.y("MESH_PRIMITIVE_INDICES_ACCESSOR_INVALID_FORMAT",new A.k4(),B.b))
q($,"Ac","tf",()=>A.y("MESH_PRIMITIVE_INCOMPATIBLE_MODE",new A.k3(),B.e))
q($,"Ai","p8",()=>A.y("MESH_PRIMITIVE_TOO_FEW_TEXCOORDS",new A.k9(),B.b))
q($,"Aj","tk",()=>A.y("MESH_PRIMITIVE_UNEQUAL_ACCESSOR_COUNT",new A.ka(),B.b))
q($,"Ag","tj",()=>A.y("MESH_PRIMITIVE_MORPH_TARGET_NO_BASE_ACCESSOR",new A.k7(),B.b))
q($,"Af","ti",()=>A.y("MESH_PRIMITIVE_MORPH_TARGET_INVALID_ATTRIBUTE_COUNT",new A.k6(),B.b))
q($,"Ak","tl",()=>A.y("NODE_LOOP",new A.kb(),B.b))
q($,"Al","tm",()=>A.y("NODE_PARENT_OVERRIDE",new A.kc(),B.b))
q($,"Ao","tp",()=>A.y("NODE_WEIGHTS_INVALID",new A.kf(),B.b))
q($,"Am","tn",()=>A.y("NODE_SKIN_WITH_NON_SKINNED_MESH",new A.kd(),B.b))
q($,"An","to",()=>A.y("NODE_SKINNED_MESH_WITHOUT_SKIN",new A.ke(),B.e))
q($,"Ap","tq",()=>A.y("SCENE_NON_ROOT_NODE",new A.kg(),B.b))
q($,"Ar","ts",()=>A.y("SKIN_IBM_INVALID_FORMAT",new A.ki(),B.b))
q($,"Aq","tr",()=>A.y("SKIN_IBM_ACCESSOR_WITH_BYTESTRIDE",new A.kh(),B.b))
q($,"As","p9",()=>A.y("TEXTURE_INVALID_IMAGE_MIME_TYPE",new A.kj(),B.b))
q($,"At","tt",()=>A.y("UNDECLARED_EXTENSION",new A.kk(),B.b))
q($,"Au","tu",()=>A.y("UNEXPECTED_EXTENSION_OBJECT",new A.kl(),B.b))
q($,"Av","T",()=>A.y("UNRESOLVED_REFERENCE",new A.km(),B.b))
q($,"Aw","tv",()=>A.y("UNSUPPORTED_EXTENSION",new A.kn(),B.h))
q($,"Az","hG",()=>A.y("UNUSED_OBJECT",new A.kq(),B.h))
q($,"Ay","tx",()=>A.y("UNUSED_MESH_WEIGHTS",new A.kp(),B.h))
q($,"Ax","tw",()=>A.y("UNUSED_MESH_TANGENT",new A.ko(),B.h))
q($,"A7","tc",()=>A.y("KHR_MATERIALS_VARIANTS_NON_UNIQUE_VARIANT",new A.jZ(),B.b))
q($,"zC","rN",()=>A.ap("GLB_INVALID_MAGIC",new A.iS(),B.b))
q($,"zD","rO",()=>A.ap("GLB_INVALID_VERSION",new A.iT(),B.b))
q($,"zF","rQ",()=>A.ap("GLB_LENGTH_TOO_SMALL",new A.iV(),B.b))
q($,"zw","rH",()=>A.ap("GLB_CHUNK_LENGTH_UNALIGNED",new A.iM(),B.b))
q($,"zE","rP",()=>A.ap("GLB_LENGTH_MISMATCH",new A.iU(),B.b))
q($,"zx","rI",()=>A.ap("GLB_CHUNK_TOO_BIG",new A.iN(),B.b))
q($,"zA","rL",()=>A.ap("GLB_EMPTY_CHUNK",new A.iQ(),B.b))
q($,"zz","rK",()=>A.ap("GLB_EMPTY_BIN_CHUNK",new A.iP(),B.h))
q($,"zy","rJ",()=>A.ap("GLB_DUPLICATE_CHUNK",new A.iO(),B.b))
q($,"zI","rT",()=>A.ap("GLB_UNEXPECTED_END_OF_CHUNK_HEADER",new A.iY(),B.b))
q($,"zH","rS",()=>A.ap("GLB_UNEXPECTED_END_OF_CHUNK_DATA",new A.iX(),B.b))
q($,"zJ","rU",()=>A.ap("GLB_UNEXPECTED_END_OF_HEADER",new A.iZ(),B.b))
q($,"zK","rV",()=>A.ap("GLB_UNEXPECTED_FIRST_CHUNK",new A.j_(),B.b))
q($,"zG","rR",()=>A.ap("GLB_UNEXPECTED_BIN_CHUNK",new A.iW(),B.b))
q($,"zL","rW",()=>A.ap("GLB_UNKNOWN_CHUNK_TYPE",new A.j0(),B.e))
q($,"zB","rM",()=>A.ap("GLB_EXTRA_DATA",new A.iR(),B.e))
q($,"Cg","pn",()=>A.vL(1))
q($,"Cl","ux",()=>A.vH())
q($,"Cr","uB",()=>A.qh())
q($,"Cn","uy",()=>{var p=A.w_()
p.a[3]=1
return p})
q($,"Co","uz",()=>A.qh())
q($,"Cf","eS",()=>A.eQ("#dropZone"))
q($,"Cm","po",()=>A.eQ("#output"))
q($,"Cj","oh",()=>A.eQ("#input"))
q($,"Ck","uw",()=>A.eQ("#inputLink"))
q($,"Cs","pq",()=>A.eQ("#truncatedWarning"))
q($,"Ct","hI",()=>A.eQ("#validityLabel"))
q($,"Cq","pp",()=>{$.pi()
return new A.m3()})})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({DataTransfer:J.aC,DOMError:J.aC,MediaError:J.aC,Navigator:J.aC,NavigatorConcurrentHardware:J.aC,NavigatorUserMediaError:J.aC,OverconstrainedError:J.aC,PositionError:J.aC,GeolocationPositionError:J.aC,ArrayBuffer:A.ft,DataView:A.cK,ArrayBufferView:A.cK,Float32Array:A.fu,Float64Array:A.fv,Int16Array:A.fw,Int32Array:A.fx,Int8Array:A.fy,Uint16Array:A.fz,Uint32Array:A.fA,Uint8ClampedArray:A.e0,CanvasPixelArray:A.e0,Uint8Array:A.cL,HTMLAudioElement:A.k,HTMLBRElement:A.k,HTMLBaseElement:A.k,HTMLBodyElement:A.k,HTMLButtonElement:A.k,HTMLCanvasElement:A.k,HTMLContentElement:A.k,HTMLDListElement:A.k,HTMLDataElement:A.k,HTMLDataListElement:A.k,HTMLDetailsElement:A.k,HTMLDialogElement:A.k,HTMLDivElement:A.k,HTMLEmbedElement:A.k,HTMLFieldSetElement:A.k,HTMLHRElement:A.k,HTMLHeadElement:A.k,HTMLHeadingElement:A.k,HTMLHtmlElement:A.k,HTMLIFrameElement:A.k,HTMLImageElement:A.k,HTMLInputElement:A.k,HTMLLIElement:A.k,HTMLLabelElement:A.k,HTMLLegendElement:A.k,HTMLLinkElement:A.k,HTMLMapElement:A.k,HTMLMediaElement:A.k,HTMLMenuElement:A.k,HTMLMetaElement:A.k,HTMLMeterElement:A.k,HTMLModElement:A.k,HTMLOListElement:A.k,HTMLObjectElement:A.k,HTMLOptGroupElement:A.k,HTMLOptionElement:A.k,HTMLOutputElement:A.k,HTMLParagraphElement:A.k,HTMLParamElement:A.k,HTMLPictureElement:A.k,HTMLPreElement:A.k,HTMLProgressElement:A.k,HTMLQuoteElement:A.k,HTMLScriptElement:A.k,HTMLShadowElement:A.k,HTMLSlotElement:A.k,HTMLSourceElement:A.k,HTMLSpanElement:A.k,HTMLStyleElement:A.k,HTMLTableCaptionElement:A.k,HTMLTableCellElement:A.k,HTMLTableDataCellElement:A.k,HTMLTableHeaderCellElement:A.k,HTMLTableColElement:A.k,HTMLTableElement:A.k,HTMLTableRowElement:A.k,HTMLTableSectionElement:A.k,HTMLTemplateElement:A.k,HTMLTextAreaElement:A.k,HTMLTimeElement:A.k,HTMLTitleElement:A.k,HTMLTrackElement:A.k,HTMLUListElement:A.k,HTMLUnknownElement:A.k,HTMLVideoElement:A.k,HTMLDirectoryElement:A.k,HTMLFontElement:A.k,HTMLFrameElement:A.k,HTMLFrameSetElement:A.k,HTMLMarqueeElement:A.k,HTMLElement:A.k,HTMLAnchorElement:A.eU,HTMLAreaElement:A.eW,Blob:A.cd,CDATASection:A.b0,CharacterData:A.b0,Comment:A.b0,ProcessingInstruction:A.b0,Text:A.b0,CSSStyleDeclaration:A.dC,MSStyleCSSProperties:A.dC,CSS2Properties:A.dC,DOMException:A.iH,DOMTokenList:A.iI,Element:A.dD,AbortPaymentEvent:A.j,AnimationEvent:A.j,AnimationPlaybackEvent:A.j,ApplicationCacheErrorEvent:A.j,BackgroundFetchClickEvent:A.j,BackgroundFetchEvent:A.j,BackgroundFetchFailEvent:A.j,BackgroundFetchedEvent:A.j,BeforeInstallPromptEvent:A.j,BeforeUnloadEvent:A.j,BlobEvent:A.j,CanMakePaymentEvent:A.j,ClipboardEvent:A.j,CloseEvent:A.j,CustomEvent:A.j,DeviceMotionEvent:A.j,DeviceOrientationEvent:A.j,ErrorEvent:A.j,ExtendableEvent:A.j,ExtendableMessageEvent:A.j,FetchEvent:A.j,FontFaceSetLoadEvent:A.j,ForeignFetchEvent:A.j,GamepadEvent:A.j,HashChangeEvent:A.j,InstallEvent:A.j,MediaEncryptedEvent:A.j,MediaKeyMessageEvent:A.j,MediaQueryListEvent:A.j,MediaStreamEvent:A.j,MediaStreamTrackEvent:A.j,MessageEvent:A.j,MIDIConnectionEvent:A.j,MIDIMessageEvent:A.j,MutationEvent:A.j,NotificationEvent:A.j,PageTransitionEvent:A.j,PaymentRequestEvent:A.j,PaymentRequestUpdateEvent:A.j,PopStateEvent:A.j,PresentationConnectionAvailableEvent:A.j,PresentationConnectionCloseEvent:A.j,PromiseRejectionEvent:A.j,PushEvent:A.j,RTCDataChannelEvent:A.j,RTCDTMFToneChangeEvent:A.j,RTCPeerConnectionIceEvent:A.j,RTCTrackEvent:A.j,SecurityPolicyViolationEvent:A.j,SensorErrorEvent:A.j,SpeechRecognitionError:A.j,SpeechRecognitionEvent:A.j,SpeechSynthesisEvent:A.j,StorageEvent:A.j,SyncEvent:A.j,TrackEvent:A.j,TransitionEvent:A.j,WebKitTransitionEvent:A.j,VRDeviceEvent:A.j,VRDisplayEvent:A.j,VRSessionEvent:A.j,MojoInterfaceRequestEvent:A.j,USBConnectionEvent:A.j,IDBVersionChangeEvent:A.j,AudioProcessingEvent:A.j,OfflineAudioCompletionEvent:A.j,WebGLContextEvent:A.j,Event:A.j,InputEvent:A.j,SubmitEvent:A.j,EventTarget:A.f9,File:A.as,FileList:A.dG,FileReader:A.fa,HTMLFormElement:A.fb,ImageData:A.dL,Location:A.kt,MouseEvent:A.aK,DragEvent:A.aK,PointerEvent:A.aK,WheelEvent:A.aK,Document:A.M,DocumentFragment:A.M,HTMLDocument:A.M,ShadowRoot:A.M,XMLDocument:A.M,Attr:A.M,DocumentType:A.M,Node:A.M,ProgressEvent:A.b3,ResourceProgressEvent:A.b3,HTMLSelectElement:A.fM,CompositionEvent:A.aW,FocusEvent:A.aW,KeyboardEvent:A.aW,TextEvent:A.aW,TouchEvent:A.aW,UIEvent:A.aW,Window:A.dh,DOMWindow:A.dh,DedicatedWorkerGlobalScope:A.bx,ServiceWorkerGlobalScope:A.bx,SharedWorkerGlobalScope:A.bx,WorkerGlobalScope:A.bx,NamedNodeMap:A.en,MozNamedAttrMap:A.en,IDBKeyRange:A.dT,SVGAElement:A.l,SVGAnimateElement:A.l,SVGAnimateMotionElement:A.l,SVGAnimateTransformElement:A.l,SVGAnimationElement:A.l,SVGCircleElement:A.l,SVGClipPathElement:A.l,SVGDefsElement:A.l,SVGDescElement:A.l,SVGDiscardElement:A.l,SVGEllipseElement:A.l,SVGFEBlendElement:A.l,SVGFEColorMatrixElement:A.l,SVGFEComponentTransferElement:A.l,SVGFECompositeElement:A.l,SVGFEConvolveMatrixElement:A.l,SVGFEDiffuseLightingElement:A.l,SVGFEDisplacementMapElement:A.l,SVGFEDistantLightElement:A.l,SVGFEFloodElement:A.l,SVGFEFuncAElement:A.l,SVGFEFuncBElement:A.l,SVGFEFuncGElement:A.l,SVGFEFuncRElement:A.l,SVGFEGaussianBlurElement:A.l,SVGFEImageElement:A.l,SVGFEMergeElement:A.l,SVGFEMergeNodeElement:A.l,SVGFEMorphologyElement:A.l,SVGFEOffsetElement:A.l,SVGFEPointLightElement:A.l,SVGFESpecularLightingElement:A.l,SVGFESpotLightElement:A.l,SVGFETileElement:A.l,SVGFETurbulenceElement:A.l,SVGFilterElement:A.l,SVGForeignObjectElement:A.l,SVGGElement:A.l,SVGGeometryElement:A.l,SVGGraphicsElement:A.l,SVGImageElement:A.l,SVGLineElement:A.l,SVGLinearGradientElement:A.l,SVGMarkerElement:A.l,SVGMaskElement:A.l,SVGMetadataElement:A.l,SVGPathElement:A.l,SVGPatternElement:A.l,SVGPolygonElement:A.l,SVGPolylineElement:A.l,SVGRadialGradientElement:A.l,SVGRectElement:A.l,SVGScriptElement:A.l,SVGSetElement:A.l,SVGStopElement:A.l,SVGStyleElement:A.l,SVGElement:A.l,SVGSVGElement:A.l,SVGSwitchElement:A.l,SVGSymbolElement:A.l,SVGTSpanElement:A.l,SVGTextContentElement:A.l,SVGTextElement:A.l,SVGTextPathElement:A.l,SVGTextPositioningElement:A.l,SVGTitleElement:A.l,SVGUseElement:A.l,SVGViewElement:A.l,SVGGradientElement:A.l,SVGComponentTransferFunctionElement:A.l,SVGFEDropShadowElement:A.l,SVGMPathElement:A.l})
hunkHelpers.setOrUpdateLeafTags({DataTransfer:true,DOMError:true,MediaError:true,Navigator:true,NavigatorConcurrentHardware:true,NavigatorUserMediaError:true,OverconstrainedError:true,PositionError:true,GeolocationPositionError:true,ArrayBuffer:true,DataView:true,ArrayBufferView:false,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false,HTMLAudioElement:true,HTMLBRElement:true,HTMLBaseElement:true,HTMLBodyElement:true,HTMLButtonElement:true,HTMLCanvasElement:true,HTMLContentElement:true,HTMLDListElement:true,HTMLDataElement:true,HTMLDataListElement:true,HTMLDetailsElement:true,HTMLDialogElement:true,HTMLDivElement:true,HTMLEmbedElement:true,HTMLFieldSetElement:true,HTMLHRElement:true,HTMLHeadElement:true,HTMLHeadingElement:true,HTMLHtmlElement:true,HTMLIFrameElement:true,HTMLImageElement:true,HTMLInputElement:true,HTMLLIElement:true,HTMLLabelElement:true,HTMLLegendElement:true,HTMLLinkElement:true,HTMLMapElement:true,HTMLMediaElement:true,HTMLMenuElement:true,HTMLMetaElement:true,HTMLMeterElement:true,HTMLModElement:true,HTMLOListElement:true,HTMLObjectElement:true,HTMLOptGroupElement:true,HTMLOptionElement:true,HTMLOutputElement:true,HTMLParagraphElement:true,HTMLParamElement:true,HTMLPictureElement:true,HTMLPreElement:true,HTMLProgressElement:true,HTMLQuoteElement:true,HTMLScriptElement:true,HTMLShadowElement:true,HTMLSlotElement:true,HTMLSourceElement:true,HTMLSpanElement:true,HTMLStyleElement:true,HTMLTableCaptionElement:true,HTMLTableCellElement:true,HTMLTableDataCellElement:true,HTMLTableHeaderCellElement:true,HTMLTableColElement:true,HTMLTableElement:true,HTMLTableRowElement:true,HTMLTableSectionElement:true,HTMLTemplateElement:true,HTMLTextAreaElement:true,HTMLTimeElement:true,HTMLTitleElement:true,HTMLTrackElement:true,HTMLUListElement:true,HTMLUnknownElement:true,HTMLVideoElement:true,HTMLDirectoryElement:true,HTMLFontElement:true,HTMLFrameElement:true,HTMLFrameSetElement:true,HTMLMarqueeElement:true,HTMLElement:false,HTMLAnchorElement:true,HTMLAreaElement:true,Blob:false,CDATASection:true,CharacterData:true,Comment:true,ProcessingInstruction:true,Text:true,CSSStyleDeclaration:true,MSStyleCSSProperties:true,CSS2Properties:true,DOMException:true,DOMTokenList:true,Element:false,AbortPaymentEvent:true,AnimationEvent:true,AnimationPlaybackEvent:true,ApplicationCacheErrorEvent:true,BackgroundFetchClickEvent:true,BackgroundFetchEvent:true,BackgroundFetchFailEvent:true,BackgroundFetchedEvent:true,BeforeInstallPromptEvent:true,BeforeUnloadEvent:true,BlobEvent:true,CanMakePaymentEvent:true,ClipboardEvent:true,CloseEvent:true,CustomEvent:true,DeviceMotionEvent:true,DeviceOrientationEvent:true,ErrorEvent:true,ExtendableEvent:true,ExtendableMessageEvent:true,FetchEvent:true,FontFaceSetLoadEvent:true,ForeignFetchEvent:true,GamepadEvent:true,HashChangeEvent:true,InstallEvent:true,MediaEncryptedEvent:true,MediaKeyMessageEvent:true,MediaQueryListEvent:true,MediaStreamEvent:true,MediaStreamTrackEvent:true,MessageEvent:true,MIDIConnectionEvent:true,MIDIMessageEvent:true,MutationEvent:true,NotificationEvent:true,PageTransitionEvent:true,PaymentRequestEvent:true,PaymentRequestUpdateEvent:true,PopStateEvent:true,PresentationConnectionAvailableEvent:true,PresentationConnectionCloseEvent:true,PromiseRejectionEvent:true,PushEvent:true,RTCDataChannelEvent:true,RTCDTMFToneChangeEvent:true,RTCPeerConnectionIceEvent:true,RTCTrackEvent:true,SecurityPolicyViolationEvent:true,SensorErrorEvent:true,SpeechRecognitionError:true,SpeechRecognitionEvent:true,SpeechSynthesisEvent:true,StorageEvent:true,SyncEvent:true,TrackEvent:true,TransitionEvent:true,WebKitTransitionEvent:true,VRDeviceEvent:true,VRDisplayEvent:true,VRSessionEvent:true,MojoInterfaceRequestEvent:true,USBConnectionEvent:true,IDBVersionChangeEvent:true,AudioProcessingEvent:true,OfflineAudioCompletionEvent:true,WebGLContextEvent:true,Event:false,InputEvent:false,SubmitEvent:false,EventTarget:false,File:true,FileList:true,FileReader:true,HTMLFormElement:true,ImageData:true,Location:true,MouseEvent:true,DragEvent:true,PointerEvent:true,WheelEvent:true,Document:true,DocumentFragment:true,HTMLDocument:true,ShadowRoot:true,XMLDocument:true,Attr:true,DocumentType:true,Node:false,ProgressEvent:true,ResourceProgressEvent:true,HTMLSelectElement:true,CompositionEvent:true,FocusEvent:true,KeyboardEvent:true,TextEvent:true,TouchEvent:true,UIEvent:false,Window:true,DOMWindow:true,DedicatedWorkerGlobalScope:true,ServiceWorkerGlobalScope:true,SharedWorkerGlobalScope:true,WorkerGlobalScope:true,NamedNodeMap:true,MozNamedAttrMap:true,IDBKeyRange:true,SVGAElement:true,SVGAnimateElement:true,SVGAnimateMotionElement:true,SVGAnimateTransformElement:true,SVGAnimationElement:true,SVGCircleElement:true,SVGClipPathElement:true,SVGDefsElement:true,SVGDescElement:true,SVGDiscardElement:true,SVGEllipseElement:true,SVGFEBlendElement:true,SVGFEColorMatrixElement:true,SVGFEComponentTransferElement:true,SVGFECompositeElement:true,SVGFEConvolveMatrixElement:true,SVGFEDiffuseLightingElement:true,SVGFEDisplacementMapElement:true,SVGFEDistantLightElement:true,SVGFEFloodElement:true,SVGFEFuncAElement:true,SVGFEFuncBElement:true,SVGFEFuncGElement:true,SVGFEFuncRElement:true,SVGFEGaussianBlurElement:true,SVGFEImageElement:true,SVGFEMergeElement:true,SVGFEMergeNodeElement:true,SVGFEMorphologyElement:true,SVGFEOffsetElement:true,SVGFEPointLightElement:true,SVGFESpecularLightingElement:true,SVGFESpotLightElement:true,SVGFETileElement:true,SVGFETurbulenceElement:true,SVGFilterElement:true,SVGForeignObjectElement:true,SVGGElement:true,SVGGeometryElement:true,SVGGraphicsElement:true,SVGImageElement:true,SVGLineElement:true,SVGLinearGradientElement:true,SVGMarkerElement:true,SVGMaskElement:true,SVGMetadataElement:true,SVGPathElement:true,SVGPatternElement:true,SVGPolygonElement:true,SVGPolylineElement:true,SVGRadialGradientElement:true,SVGRectElement:true,SVGScriptElement:true,SVGSetElement:true,SVGStopElement:true,SVGStyleElement:true,SVGElement:true,SVGSVGElement:true,SVGSwitchElement:true,SVGSymbolElement:true,SVGTSpanElement:true,SVGTextContentElement:true,SVGTextElement:true,SVGTextPathElement:true,SVGTextPositioningElement:true,SVGTitleElement:true,SVGUseElement:true,SVGViewElement:true,SVGGradientElement:true,SVGComponentTransferFunctionElement:true,SVGFEDropShadowElement:true,SVGMPathElement:true})
A.db.$nativeSuperclassTag="ArrayBufferView"
A.eo.$nativeSuperclassTag="ArrayBufferView"
A.ep.$nativeSuperclassTag="ArrayBufferView"
A.e_.$nativeSuperclassTag="ArrayBufferView"
A.eq.$nativeSuperclassTag="ArrayBufferView"
A.er.$nativeSuperclassTag="ArrayBufferView"
A.aF.$nativeSuperclassTag="ArrayBufferView"})()
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q)s[q].removeEventListener("load",onLoad,false)
a(b.target)}for(var r=0;r<s.length;++r)s[r].addEventListener("load",onLoad,false)})(function(a){v.currentScript=a
var s=A.yv
if(typeof dartMainRunner==="function")dartMainRunner(s,[])
else s([])})})()