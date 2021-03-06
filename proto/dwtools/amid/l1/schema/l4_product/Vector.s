( function _Vector_s_( ) {

'use strict';

//

let _ = _global_.wTools;

//

let Parent = _.schema.Product;
let Self = function wSchemaProductVector( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'ProductVector';

// --
// inter
// --

function _form2()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( !product.elementsArray )
  if( !product._formElements() )
  return false;

  for( let i = 0 ; i < product.elementsArray.length ; i++ )
  {
    let element = product.elementsArray[ i ];
    let elementDefinition = sys.definition( element.type );
    if( !elementDefinition.product )
    return false;
  }

  product._formUsing();

  _.mapExtend( product, _.mapBut( def.opts, { extend : null, supplement : null } ) );

  return true;
}

//

function _form3()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  product._formUsing();

  return true;
}

//

function _formUsing()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  for( let i = 0 ; i < product.elementsArray.length ; i++ )
  {
    let element = product.elementsArray[ i ];
    let elementDefinition = sys.definition( element.type );

    _.arrayAppendOnce( elementDefinition.product.usedByProducts, product );
    _.arrayAppendOnce( product.usesProducts, elementDefinition.product );

  }

}

// --
// elements
// --

function _formElements()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  let done = true;

  _.assert( product.elementsMap === null );
  _.assert( product.elementsArray === null );

  product.elementsMap = Object.create( null );
  product.elementsArray = [];

  if( done )
  amend( def.opts.supplement, 'supplement' );
  if( done )
  amend( def.opts.extend, 'extend' );

  if( !done )
  {
    product.elementsMap = null;
    product.elementsArray = null;
  }

  if( done )
  {
    includedNormalize();
    _.assert( _.longHas( [ 'left', 'right', null ], product.bias ) );
  }

  return done;

  /* */

  function includedNormalize()
  {
    for( let i = 0 ; i < product.elementsArray.length ; i++ )
    {
      let element = product.elementsArray[ i ];
      if( element.including === null )
      if( element.name )
      element.including = true;
    }
    let statistics = product.elementsStatistics();
    if( statistics.unknown )
    for( let i = 0 ; i < product.elementsArray.length ; i++ )
    {
      let element = product.elementsArray[ i ];
      if( element.including === null )
      element.including = !statistics.including;
    }

  }

  function amend( amends, amending )
  {

    for( let e = 0 ; e < amends.length ; e++ )
    {
      let amend = amends[ e ];
      done = product._elementsAmmend( amend, amending );
      if( !done )
      break;
    }

    return done;
  }

}

//

function _elementsAmmend( elements, amending )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( def.IsNameOrId( elements ) )
  {
    debugger;
    elements = sys.definition( elements );
    if( elements.formed < 2 )
    return false;

    elements = elements.product.elementsArray;
    _.assert( _.arrayIs( elements ) );
    for( let i = 0 ; i < elements.length ; i++ )
    {
      let e = elements[ i ];
      let e2 = _.mapExtend( null, e );
      /* xxx : change index? */
      product._elementMakeAct( e2, amending );
    }

  }
  else if( _.mapIs( elements ) )
  {
    let i = 0;
    for( let k in elements )
    {
      let e = elements[ k ];
      product._elementMake( e, k, i, amending );
      i += 1;
    }
  }
  else if( _.longIs( elements ) )
  {
    for( let i = 0 ; i < elements.length ; i++ )
    {
      let e = elements[ i ];
      product._elementMake( e, null, i, amending );
    }
  }
  else _.assert( 0 );

  return true;
}

//

function elementsStatistics()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  let result = Object.create( null );
  result.including = 0;
  result.excluded = 0;
  result.unknown = 0;
  for( let i = 0 ; i < product.elementsArray.length ; i++ )
  {
    let element = product.elementsArray[ i ];
    _.assert( _.longHas( [ true, false, null ], element.including ) );
    if( element.including === true )
    result.including += 1;
    else if( element.including === false )
    result.excluded += 1;
    else
    result.unknown += 1;
  }

  return result;
}

//

function _elementMake( elementOptions, name, index, amending )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assert( def.formed === 1 );
  _.assert( arguments.length === 4 );
  _.assert( name === null || _.strDefined( name ) );
  _.assert( _.numberIs( index ) );
  _.assert( _.strIs( elementOptions ) || _.numberIs( elementOptions ) || _.mapIs( elementOptions ) || elementOptions === _.nothing || elementOptions === _.anything );
  _.assert( _.longHas( [ 'extend', 'supplement' ], amending ) );

  let element = Object.create( null );
  if( _.strIs( elementOptions ) || _.numberIs( elementOptions ) || elementOptions === _.nothing || elementOptions === _.anything )
  element.type = elementOptions;
  else
  _.mapExtend( element, elementOptions );

  if( name !== null )
  element.name = name;
  else if( element.name === undefined )
  element.name = null;

  if( index !== null )
  element.index = index;

  return product._elementMakeAct( element, amending );
}

//

function _elementMakeAct( element, amending )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  let hadElement = element.name !== null ? product.elementsMap[ element.name ] : undefined;

  _.assert( def.formed === 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.longHas( [ 'extend', 'supplement' ], amending ) );
  _.assert( _.mapIs( element ) )
  _.assert( element.name === null || _.strDefined( element.name ) );
  _.assert( _.numberIs( element.index ) && element.index >= 0 );

  if( hadElement )
  {
    if( amending === 'supplement' )
    return null;
  }

  if( element.type === _.nothing || element.type === _.anything )
  {
    let universalDefinition = sys.definition( element.type );
    element.type = universalDefinition.id;
  }
  else if( def.IsDefinitionString( element.type ) )
  {
    let definition2 = sys.define().fromDefinitionString( element.type ).fromFieldsTolerant( element );
    _.assert( definition2.id >= 1 );
    _.mapDelete( element, definition2.typeToProductClass().Fields );
    element.type = definition2.id;
  }

  if( element.type === undefined || element.type === null )
  if( hadElement && hadElement.type )
  {
    debugger;
    element.type = hadElement.type;
  }

  let redundant = _.mapBut( element, product.ElementExtendedFields );
  if( _.lengthOf( redundant ) > 0 )
  {
    redundant.type = element.type;
    _.assert( redundant.name === undefined );
    let definition2 = sys.define();
    if( redundant.multiple !== undefined )
    definition2.multiplier( redundant );
    else
    definition2.alias( redundant );
    _.assert( definition2.id >= 1 );
    element.type = definition2.id;
    _.mapDelete( element, _.mapBut( definition2.typeToProductClass().Fields, product.ElementExtendedFields ) );
  }

  if( element.including === undefined )
  element.including = null;
  if( _.boolLike( element.including ) )
  element.including = !!element.including;

  // _.assertMapHasOnly( element, product.ElementExtendedFields );
  // _.assert( _.strIs( element.type ) || _.numberIs( element.type ) );
  // _.assert( sys.definition( element.type ) instanceof _.schema.Definition );
  // _.assert( element.name === null || _.strDefined( element.name ) );
  // _.assert( _.numberIs( element.index ) );

  if( element.name !== null )
  {
    if( hadElement )
    _.arrayRemoveOnceStrictly( product.elementsArray, hadElement );
    product.elementsMap[ element.name ] = element;
  }

  product.elementsArray.push( element );
  element.index = product.elementsArray.indexOf( element );

  _.assertMapHasOnly( element, product.ElementExtendedFields );
  _.assert( _.strIs( element.type ) || _.numberIs( element.type ) );
  _.assert( sys.definition( element.type ) instanceof _.schema.Definition );
  _.assert( element.name === null || _.strDefined( element.name ) );
  _.assert( _.numberIs( element.index ) );

  return element;
}

//

function elementDescriptor( key )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  let result;

  if( _.numberIs( key ) )
  result = product.elementsArray[ key ];
  else
  result = product.elementsMap[ key ];

  _.assert( _.mapIs( result ) );
  return result;
}

//

function elementDefinition( key )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  return sys.definition( product.elementDescriptor( key ).type );
}

//

function elementProduct( key )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  return product.elementDefinition( key ).product;
}

// --
// exporter
// --

function _elementsExportStructure( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  o = _.routineOptions( _elementsExportStructure, arguments );
  _.assert( !!product.elementsArray );

  if( o.dst === null )
  o.dst = [];
  if( o.elements === null )
  o.elements = product.elementsArray;

  for( let i = 0 ; i < o.elements.length ; i++ )
  {
    let element = o.elements[ i ];
    let elementStructure = Object.create( null );
    elementStructure.type = element.type;
    elementStructure.name = element.name;
    o.dst.push( elementStructure );
  }

  return o.dst;
}

_elementsExportStructure.defaults =
{
  ... Parent.prototype.exportStructure.defaults,
  elements : null,
}

//

function _elementsExportInfo( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  let result = '';
  let statistics;

  if( o.format === 'grammar' )
  statistics = product.elementsStatistics();

  o = _.routineOptions( _elementsExportInfo, arguments );

  if( o.dst === null )
  o.dst = [];
  if( o.structure === null )
  {
    debugger;
    let o2 = _.mapOnly( o, product._elementsExportStructure.defaults );
    o.structure = product._elementsExportStructure( o2 );
  }

  for( let i = 0 ; i < o.structure.length ; i++ )
  {
    let elementStructure = o.structure[ i ];
    let typeDef = sys.definition( elementStructure.type );

    if( o.format === 'dump' )
    {
      if( result )
      result += '\n';
      result += `    ${ typeDef.name || typeDef.id } :: ${ elementStructure.name || '' }`;
    }
    else
    {
      if( result )
      result += '\n';
      let elementName = elementStructure.name;
      if( elementName )
      elementName = '@' + elementName + ' ';
      if( elementStructure.including )
      {
        if( statistics.excluded )
        result += `  ${ elementName || '' }:= ${ typeDef.name || typeDef.id }`;
        else if( elementName )
        result += `  ${ elementName || '' }:= ${ typeDef.name || typeDef.id }`;
        else
        result += `  ${ typeDef.name || typeDef.id }`;
      }
      else
      {
        result += `  ${ typeDef.name || typeDef.id }`;
      }
    }

  }

  return result;
}

_elementsExportInfo.defaults =
{
  ... _.schema.System.prototype.exportInfo.defaults,
  name : null,
}

//

function exportStructure( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  o = _.routineOptions( exportStructure, arguments );

  Parent.prototype.exportStructure.call( product, o );

  o.dst.elements = [];

  let o2 = _.mapExtend( null, o );
  o2.elements = product.elementsArray;
  o2.dst = o.dst.elements;
  product._elementsExportStructure( o2 );

  return o.dst;
}

exportStructure.defaults =
{
  ... Parent.prototype.exportStructure.defaults,
}

//

function _exportInfo( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.routineOptions( _exportInfo, arguments );
  _.assert( o.structure !== null );

  return product._exportInfoVector( o );
}

_exportInfo.defaults =
{
  ... _.schema.Product.prototype._exportInfo.defaults,
}

//

function _exportInfoVector( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.routineOptions( _exportInfoVector, arguments );
  _.assert( o.structure !== null );

  /*
  optimization gives :
`
  /exp_mul
  (.<
    @left := exp
    mul
    @right := exp
  )
`
  instead of
`
  #13 :=
  (<
    @left := exp
    mul
    @right := exp
  )
  /exp_mul := (. #13 )
`
  */

  debugger;
  if( o.optimizing && !def.name && !o.name )
  if( product.usedByProducts.length === 1 && product.usedByProducts[ 0 ].definition.kind === def.Kind.container )
  {
    return '';
  }

  let o2 = _.mapOnly( o, Parent.prototype._exportInfo.defaults );
  let result = Parent.prototype._exportInfo.call( this, o2 );

  let o3 = _.mapExtend( null, o2 );
  o3.structure = product.elementsArray;
  let result2 = product._elementsExportInfo( o3 );

  if( o.format === 'dump' )
  {
    if( result2 )
    result += `\n  elements\n${result2}`;
  }
  else
  {
    result += ' :=';

    result += '\n' + o.opener;
    if( o.prefix )
    result += o.prefix;
    if( product.bias === 'left' )
    result += '>';
    else if( product.bias === 'right' )
    result += '<';
    if( result2 )
    result += `\n${result2}`;
    if( o.postfix )
    result += o.postfix;
    result += '\n' + o.closer;
  }

  return result;
}

_exportInfoVector.defaults =
{
  ... _exportInfo.defaults,
  opener : null,
  closer : null,
  prefix : '',
  postfix : '',
}

// --
// relations
// --

let Fields =
{
  extend : null,
  supplement : null,
  bias : null,
}

let Composes =
{
}

let Aggregates =
{
  elementsMap : null,
  elementsArray : null,
  bias : null,
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  Fields,
}

let Forbids =
{
}

let Accessors =
{
}

// --
// define class
// --

let Proto =
{

  // inter

  _form2,
  _form3,

  _formUsing,

  // elements

  _formElements,
  _elementsAmmend,
  elementsStatistics,
  _elementMake,
  _elementMakeAct,

  elementDescriptor,
  elementDefinition,
  elementProduct,

  // exporter

  _elementsExportStructure,
  _elementsExportInfo,

  exportStructure,
  _exportInfo,
  _exportInfoVector,

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

_.schema[ Self.shortName ] = Self;
if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
