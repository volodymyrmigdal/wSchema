( function _Universal_s_( ) {

'use strict';

//

let _ = _global_.wTools;

//

let Parent = _.schema.Product;
let Self = function wSchemaProductUniversal( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'ProductUniversal';

// --
// inter
// --

function _form2()
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.mapExtend( product, def.opts );
  _.assert( _.symbolIs( product.symbol ), 'Expects field {- symbol -}' );

  return true;
}

//

function _makeDefaultAct( it )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;
  it.onElementAdd({ value : _.nothing });
  // return _.nothing;
  // throw _.err( `Cant make default for ${product.qualifiedName}. Universal definitions cant have default value.` );
}

//

function _isTypeOfStructureAct( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  if( product.symbol === product.Symbol.anything )
  {
    debugger;
    return true;
  }
  else if( product.symbol === product.Symbol.nothing )
  {
    debugger;
    return false;
  }
  else _.assert( 0 );

  return false;
}

//

function _exportInfo( o )
{
  let product = this;
  let def = product.definition;
  let sys = def.sys;

  _.assertRoutineOptions( _exportInfo, arguments );
  _.assert( o.structure !== null );

  if( o.format === 'dump' )
  return Parent.prototype._exportInfo.call( this, o );

  let result; debugger;

  if( product.symbol === _.anything )
  result = `${product.grammarName} := ( type = anything )`;
  else
  result = `${product.grammarName} := ( type = nothing )`;

  return result;
}

_exportInfo.defaults =
{
  ... _.schema.Product.prototype._exportInfo.defaults,
}

// --
// relations
// --

let Symbols =
{
  anything : _.anything,
  nothing : _.nothing,
}

let Fields =
{
  symbol : null,
}

let Composes =
{
}

let Aggregates =
{
  symbol : null,
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
  Symbols,
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
  _makeDefaultAct,
  _isTypeOfStructureAct,
  _exportInfo,

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
