import Store from '../store';
import { apiUrl } from '../../config/browser';
import { getJson } from '../common/http';
import { List, fromJS } from 'immutable';

const PRODUCTS = Symbol.for('products');

Store.initObservable(PRODUCTS, new List());

let cachedGetAll = null;

function parseProduct(product) {
  product.price = parseFloat(product.price);
  product.buyCount = parseInt(product.buyCount);
  product.createdAt = new Date(product.createdAt);
  product.updatedAt = new Date(product.updatedAt);
  product.lastBoughtAt = product.lastBoughtAt ? new Date(product.lastBoughtAt) : null;
}

export function getAll(reload = false) {
  if (reload || !cachedGetAll) {
    cachedGetAll = getJson(apiUrl('products'))
      .then((response)=> {
        response.products.forEach(parseProduct);
        Store.publish(PRODUCTS, fromJS(response.products));
      })
      .catch(message=> message);
  }
  return cachedGetAll;
}
