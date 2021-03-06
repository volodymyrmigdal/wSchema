( function _Product_s_( ) {

'use strict';

//

let _ = _global_.wTools;

//

let Parent = null;
let Self = function wSchemaProduct( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Product';

// --
// inter
// --

function init( o )
{
  let product = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( product );
  Object.preventExtensions( product );

  if( o )
  product.copy( o );

  _.assert( product.definition instanceof _.schema.Definition );

  product.form1();

  return product;
}

//

function form1()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( product.formed )
  return true

  let result = product._form1 !== null ? product._form1() : undefined;
  _.assert( result === undefined );

  product.formed = 1;
  return true;
}

//

function form2()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( product.formed >= 2 )
  return true

  if( def.name && def.kind !== def.Kind.universal )
  if( _.strHas( def.name, '❮' ) || _.strHas( def.name, '❯' ) )
  throw _.err( `Only universal definitions could have "❮" or "❯" in name. Illegal name of definition ${product.qualifiedName}` );

  _.assertMapHasOnly( def.opts, product.Fields );

  let result = product._form2();
  _.assert( _.boolIs( result ) );

  if( result )
  {
    product.formed = 2;
    _.arrayRemoveOnceStrictly( sys.definitionsToForm2Array, def );
    _.arrayAppendOnceStrictly( sys.definitionsToForm3Array, def );
  }

  return result;
}

//

function form3()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( product.formed >= 3 )
  return true

  let result = product._form3 !== null ? product._form3() : true;
  _.assert( _.boolIs( result ) );

  if( result )
  {
    product.formed = 3;
    _.arrayRemoveOnceStrictly( sys.definitionsToForm3Array, def );
  }

  return result;
}
//
// //
//
// function _elementsAmmend( elements, amending )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//
//   if( def.IsNameOrId( elements ) )
//   {
//     debugger;
//     elements = sys.definition( elements );
//     if( elements.formed < 2 )
//     return false;
//
//     elements = elements.product.elementsArray;
//     _.assert( _.arrayIs( elements ) );
//     for( let i = 0 ; i < elements.length ; i++ )
//     {
//       let e = elements[ i ];
//       let e2 = _.mapExtend( null, e );
//       /* xxx : change index? */
//       product._elementMakeAct( e2, amending );
//     }
//
//   }
//   else if( _.mapIs( elements ) )
//   {
//     let i = 0;
//     for( let k in elements )
//     {
//       let e = elements[ k ];
//       product._elementMake( e, k, i, amending );
//       i += 1;
//     }
//   }
//   else if( _.longIs( elements ) )
//   {
//     for( let i = 0 ; i < elements.length ; i++ )
//     {
//       let e = elements[ i ];
//       product._elementMake( e, null, i, amending );
//     }
//   }
//   else _.assert( 0 );
//
//   return true;
// }
//
// //
//
// function elementsStatistics()
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//
//   let result = Object.create( null );
//   result.including = 0;
//   result.excluded = 0;
//   result.unknown = 0;
//   for( let i = 0 ; i < product.elementsArray.length ; i++ )
//   {
//     let element = product.elementsArray[ i ];
//     _.assert( _.longHas( [ true, false, null ], element.including ) );
//     if( element.including === true )
//     result.including += 1;
//     else if( element.including === false )
//     result.excluded += 1;
//     else
//     result.unknown += 1;
//   }
//
//   return result;
// }
//
// //
//
// function _elementMake( elementOptions, name, index, amending )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//
//   _.assert( def.formed === 1 );
//   _.assert( arguments.length === 4 );
//   _.assert( name === null || _.strDefined( name ) );
//   _.assert( _.numberIs( index ) );
//   _.assert( _.strIs( elementOptions ) || _.numberIs( elementOptions ) || _.mapIs( elementOptions ) || elementOptions === _.nothing || elementOptions === _.anything );
//   _.assert( _.longHas( [ 'extend', 'supplement' ], amending ) );
//
//   let element = Object.create( null );
//   if( _.strIs( elementOptions ) || _.numberIs( elementOptions ) || elementOptions === _.nothing || elementOptions === _.anything )
//   element.type = elementOptions;
//   else
//   _.mapExtend( element, elementOptions );
//
//   if( name !== null )
//   element.name = name;
//   else if( element.name === undefined )
//   element.name = null;
//
//   if( index !== null )
//   element.index = index;
//
//   return product._elementMakeAct( element, amending );
// }
//
// //
//
// function _elementMakeAct( element, amending )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//   let hadElement = element.name !== null ? product.elementsMap[ element.name ] : undefined;
//
//   _.assert( def.formed === 1 );
//   _.assert( arguments.length === 2 );
//   _.assert( _.longHas( [ 'extend', 'supplement' ], amending ) );
//   _.assert( _.mapIs( element ) )
//   _.assert( element.name === null || _.strDefined( element.name ) );
//   _.assert( _.numberIs( element.index ) && element.index >= 0 );
//
//   if( hadElement )
//   {
//     if( amending === 'supplement' )
//     return null;
//   }
//
//   if( element.type === _.nothing || element.type === _.anything )
//   {
//     let universalDefinition = sys.definition( element.type );
//     element.type = universalDefinition.id;
//   }
//   else if( def.IsDefinitionString( element.type ) )
//   {
//     let definition2 = sys.define().fromDefinitionString( element.type ).fromFieldsTolerant( element );
//     _.assert( definition2.id >= 1 );
//     _.mapDelete( element, definition2.typeToProductClass().Fields );
//     element.type = definition2.id;
//   }
//
//   if( element.type === undefined || element.type === null )
//   if( hadElement && hadElement.type )
//   {
//     debugger;
//     element.type = hadElement.type;
//   }
//
//   let redundant = _.mapBut( element, product.ElementExtendedFields );
//   if( _.lengthOf( redundant ) > 0 )
//   {
//     redundant.type = element.type;
//     _.assert( redundant.name === undefined );
//     let definition2 = sys.define();
//     if( redundant.multiple !== undefined )
//     definition2.multiplier( redundant );
//     else
//     definition2.alias( redundant );
//     _.assert( definition2.id >= 1 );
//     element.type = definition2.id;
//     _.mapDelete( element, _.mapBut( definition2.typeToProductClass().Fields, product.ElementExtendedFields ) );
//   }
//
//   if( element.including === undefined )
//   element.including = null;
//   if( _.boolLike( element.including ) )
//   element.including = !!element.including;
//
//   _.assertMapHasOnly( element, product.ElementExtendedFields );
//   _.assert( _.strIs( element.type ) || _.numberIs( element.type ) );
//   _.assert( sys.definition( element.type ) instanceof _.schema.Definition );
//   _.assert( element.name === null || _.strDefined( element.name ) );
//   _.assert( _.numberIs( element.index ) );
//
//   if( element.name !== null )
//   {
//     if( hadElement )
//     _.arrayRemoveOnceStrictly( product.elementsArray, hadElement );
//     product.elementsMap[ element.name ] = element;
//   }
//
//   product.elementsArray.push( element );
//
//   return element;
// }

//

function _containerAutoTypeGetAct()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed >= 2 );
  _.assert( arguments.length === 0 );

  return null;
}

//

function containerAutoTypeGet()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed >= 2 );
  _.assert( arguments.length === 0 );

  if( product._containerAutoTypeGetAct )
  return product._containerAutoTypeGetAct();

  throw _.err( `Method::_containerAutoTypeGetAct is not implemented for ${product.quotedName}` );
}

// --
// productor
// --

function _makeDefaultFromDefault( it )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( arguments.length === 1 );

  if( product.default === undefined || product.default === null )
  {
    debugger;
    throw _.err( `${product.qualifiedName} does not have defined {- default -}` );
  }

  it.onElementAdd({ value : _.make( product.default ) });

}

//

function _makeDefaultSingletone( it )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( product.type !== undefined );
  _.assert( arguments.length === 1 );

  if( product.default === null )
  {
    let originalDefinition = sys.definition( product.type );
    let r = originalDefinition.product._makeDefaultAct( it );
    _.assert( r === undefined );
    return;
  }

  let r = product._makeDefaultFromDefault( it );
  _.assert( r === undefined );
}

//

function _makeDefaultIteration( src )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  let it = src ? _.mapExtend( null, src ) : Object.create( null );
  // it.onElementAdd = null;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return it;
}

//

function makeDefault()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed >= 2 ); /* xxx : remove the field? */
  _.assert( product.formed >= 2 );
  _.assert( arguments.length === 0 );

  let it = product._makeDefaultIteration();
  it.container = [];
  it.onElementAdd = onElementAdd;
  let r = product._makeDefaultAct( it );

  if( it.container.length === 0 )
  throw _.err( `No container defined in ${product.qualifiedName} to put elements, got none elements` );
  if( it.container.length !== 1 )
  throw _.err( `No container defined in ${product.qualifiedName} to put elements, got ${it.container.length} elements` );

  return it.container[ 0 ];

  function onElementAdd( o )
  {
    if( o.value === _.nothing )
    throw _.err( `Failed to make default for ${ product.qualifiedName }` );
    it.container.push( o.value );
    // debugger;
    // _.assert( it.result === undefined );
    // it.result = r;
  }

}

//

function _isTypeOfStructure( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assertRoutineOptions( isTypeOfStructure, arguments );

  _.assert( o.src !== _.null );
  _.assert( _.routineIs( product._isTypeOfStructureAct ), `${product.qualifiedName} does not have implemented method _isTypeOfStructureAct` );
  let result = product._isTypeOfStructureAct( o );
  _.assert( _.boolIs( result ) );

  return result;
}

_isTypeOfStructure.defaults =
{
  src : _.null,
  rootSrc : _.null,
  definition : null,
  rootDefinition : null,
}

//

function isTypeOfStructure( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed >= 2 );
  _.assert( product.formed >= 2 );
  _.assert( arguments.length === 1 );
  _.routineOptions( isTypeOfStructure, arguments );

  if( o.rootSrc === _.null )
  o.rootSrc = o.src;
  if( o.definition === null )
  o.definition = def;
  if( o.rootDefinition === null )
  o.rootDefinition = o.definition;

  _.assert( o.src !== _.null );
  let result = product._isTypeOfStructure( o );
  _.assert( _.boolIs( result ) );
  return result;
}

isTypeOfStructure.defaults =
{
  ... _isTypeOfStructure.defaults,
}

//

function _isTypeOfDefinition( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assertRoutineOptions( isTypeOfDefinition, arguments );
  _.assert( o.src !== _.null );
  _.assert( _.routineIs( product._isTypeOfDefinitionAct ), `${product.qualifiedName} does not have implemented method _isTypeOfDefinitionAct` );
  let result = product._isTypeOfDefinitionAct( o );
  _.assert( _.boolIs( result ) );
  return result;
}

_isTypeOfDefinition.defaults =
{
  src : _.null,
  rootSrc : _.null,
  rootDefinition : null,
}

//

function isTypeOfDefinition( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed >= 2 );
  _.assert( product.formed >= 2 );
  _.assert( arguments.length === 1 );
  _.routineOptions( isTypeOfDefinition, arguments );

  if( o.rootSrc === _.null )
  o.rootSrc = o.src;
  if( o.rootDefinition === null )
  o.rootDefinition = def;

  _.assert( o.src !== _.null );
  let result = product._isTypeOfDefinition( o );
  _.assert( _.boolIs( result ) );
  return result;
}

isTypeOfDefinition.defaults =
{
  ... _isTypeOfDefinition.defaults,
}

// --
// exporter
// --

function exportStructure( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  o = _.routineOptions( exportStructure, arguments );

  if( o.dst === null )
  o.dst = Object.create( null );

  o.dst.name = def.name;
  o.dst.kind = def.KindNameToId.forVal( def.kind );
  o.dst.id = def.id;

  _.mapExtend( o.dst, _.mapOnly( product, product.Fields ) );

  if( o.compacting )
  o.dst = product.fieldsCompact( o.dst );

  return o.dst;
}

exportStructure.defaults =
{
  ... _.schema.System.prototype.exportStructure.defaults,
}

//

function exportInfo( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  o = _.routineOptions( exportInfo, arguments );

  if( o.structure === null )
  o.structure = def.exportStructure( _.mapOnly( o, def.exportStructure.defaults ) );

  return product._exportInfo( o );
}

exportInfo.defaults =
{
  ... _.schema.System.prototype.exportInfo.defaults,
  name : null,
}

//

function _exportInfo( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assertRoutineOptions( exportInfo, arguments );
  _.assert( o.structure !== null );

  if( o.format === 'dump' )
  {
    let result = o.name ? o.name : def._longNameFromStructure( o.structure );
    let structure = _.mapBut( o.structure, [ 'name', 'kind', 'id', 'elements' ] );
    if( structure.subtype )
    structure.subtype = !!structure.subtype;
    if( _.lengthOf( structure ) )
    result += '\n' + _.toStrNice( structure );
    return result;
  }
  else
  {
    let result = o.name ? def.GrammarNameFor( o.name ) : product.grammarName;
    return result;
  }

}

_exportInfo.defaults =
{
  ... exportInfo.defaults,
}

// //
//
// function _exportInfoVector( o )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//
//   _.routineOptions( _exportInfoVector, arguments );
//   _.assert( o.structure !== null );
//
//   /*
//   optimization gives :
// `
//   /exp_mul
//   (.<
//     @left := exp
//     mul
//     @right := exp
//   )
// `
//   instead of
// `
//   #13 :=
//   (<
//     @left := exp
//     mul
//     @right := exp
//   )
//   /exp_mul := (. #13 )
// `
//   */
//
//   if( o.optimizing && !def.name && !o.name )
//   if( product.usedByProducts.length === 1 && product.usedByProducts[ 0 ].definition.kind === def.Kind.container )
//   {
//     return '';
//   }
//
//   let o2 = _.mapOnly( o, Self.prototype._exportInfo.defaults );
//   let result = Self.prototype._exportInfo.call( this, o2 );
//
//   let o3 = _.mapExtend( null, o2 );
//   o3.structure = product.elementsArray;
//   let result2 = product._elementsExportInfo( o3 );
//
//   if( o.format === 'dump' )
//   {
//     if( result2 )
//     result += `\n  elements\n${result2}`;
//   }
//   else
//   {
//     result += ' :=';
//
//     result += '\n' + o.opener;
//     if( o.prefix )
//     result += o.prefix;
//     if( product.bias === 'left' )
//     result += '>';
//     else if( product.bias === 'right' )
//     result += '<';
//     if( result2 )
//     result += `\n${result2}`;
//     if( o.postfix )
//     result += o.postfix;
//     result += '\n' + o.closer;
//   }
//
//   return result;
// }
//
// _exportInfoVector.defaults =
// {
//   ... _exportInfo.defaults,
//   opener : null,
//   closer : null,
//   prefix : '',
//   postfix : '',
// }
//
// //
//
// function _elementsExportStructure( o )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//
//   o = _.routineOptions( _elementsExportStructure, arguments );
//   _.assert( !!product.elementsArray );
//
//   if( o.dst === null )
//   o.dst = [];
//   if( o.elements === null )
//   o.elements = product.elementsArray;
//
//   for( let i = 0 ; i < o.elements.length ; i++ )
//   {
//     let element = o.elements[ i ];
//     let elementStructure = Object.create( null );
//     elementStructure.type = element.type;
//     elementStructure.name = element.name;
//     o.dst.push( elementStructure );
//   }
//
//   return o.dst;
// }
//
// _elementsExportStructure.defaults =
// {
//   ... exportStructure.defaults,
//   elements : null,
// }
//
// //
//
// function _elementsExportInfo( o )
// {
//   let product = this;
//   let def = product.definition;
//   let sys = def.sys;
//   let result = '';
//   let statistics;
//
//   if( o.format === 'grammar' )
//   statistics = product.elementsStatistics();
//
//   o = _.routineOptions( _elementsExportInfo, arguments );
//
//   if( o.dst === null )
//   o.dst = [];
//   if( o.structure === null )
//   {
//     debugger;
//     let o2 = _.mapOnly( o, product._elementsExportStructure.defaults );
//     o.structure = product._elementsExportStructure( o2 );
//   }
//
//   for( let i = 0 ; i < o.structure.length ; i++ )
//   {
//     let elementStructure = o.structure[ i ];
//     let typeDef = sys.definition( elementStructure.type );
//
//     if( o.format === 'dump' )
//     {
//       if( result )
//       result += '\n';
//       result += `    ${ typeDef.name || typeDef.id } :: ${ elementStructure.name || '' }`;
//     }
//     else
//     {
//       if( result )
//       result += '\n';
//       let elementName = elementStructure.name;
//       if( elementName )
//       elementName = '@' + elementName + ' ';
//       if( elementStructure.including )
//       {
//         if( statistics.excluded )
//         result += `  ${ elementName || '' }:= ${ typeDef.name || typeDef.id }`;
//         else if( elementName )
//         result += `  ${ elementName || '' }:= ${ typeDef.name || typeDef.id }`;
//         else
//         result += `  ${ typeDef.name || typeDef.id }`;
//       }
//       else
//       {
//         result += `  ${ typeDef.name || typeDef.id }`;
//       }
//     }
//
//   }
//
//   return result;
// }
//
// _elementsExportInfo.defaults =
// {
//   ... _.schema.System.prototype.exportInfo.defaults,
//   name : null,
//   // ... exportStructure.defaults,
//   // structure : null,
//   // format : 'dump',
//   // name : null,
// }

//

function fieldsCompact( dsts )
{
  let resource = this;
  let module = resource.module;

  _.filter_( dsts, ( dst, k ) =>
  {

    if( dst === null )
    {
      dst = undefined;
      return;
    }

    if( _.arrayIs( dst ) && !dst.length )
    {
      dst = undefined;
      return;
    }

    if( _.mapIs( dst ) && !_.mapKeys( dst ).length )
    {
      dst = undefined;
      return;
    }

    return dst;
  });

  return dsts;
}

//

function _qualifiedNameGet()
{
  let product = this;
  let def = product.definition;
  return `${product.constructor.shortName}::${def.name || def.id}`;
}

//

function _grammarNameGet()
{
  let product = this;
  let def = product.definition;
  return def.grammarName;
}

// --
// relations
// --

let ElementFields =
{
  type : null,
  including : true,
}

let ElementExtendedFields =
{
  type : null,
  including : true,
  name : null,
  index : null,
}

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
  definition : null,
}

let Restricts =
{
  formed : 0,
  usesProducts : _.define.own( [] ),
  usedByProducts : _.define.own( [] ),
}

let Statics =
{
  ElementFields,
  ElementExtendedFields,
}

let Forbids =
{
}

let Accessors =
{
  grammarName : {},
}

// --
// define class
// --

let Proto =
{

  // inter

  init,
  _form1 : null,
  _form2 : null,
  _form3 : null,
  form1,
  form2,
  form3,

  // _formComplex,
  // _elementsAmmend,
  // elementsStatistics,
  // _elementMake,
  // _elementMakeAct,

  // etc

  _containerAutoTypeGetAct,
  containerAutoTypeGet,

  // productor

  _makeDefaultAct : null,
  _makeDefaultFromDefault,
  _makeDefaultSingletone,
  _makeDefaultIteration,
  makeDefault,

  _isTypeOfStructureAct : null,
  _isTypeOfStructure,
  isTypeOfStructure,

  _isTypeOfDefinitionAct : null,
  _isTypeOfDefinition,
  isTypeOfDefinition,

  // exporter

  exportStructure,
  exportInfo,
  _exportInfo,
  // _exportInfoVector,
  // _elementsExportStructure,
  // _elementsExportInfo,
  fieldsCompact,
  _qualifiedNameGet,
  _grammarNameGet,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.schema[ Self.shortName ] = Self;
if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
