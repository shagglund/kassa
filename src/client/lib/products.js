import RestWrapper from './common/rest_wrapper';

class ProductStore extends RestWrapper {
  constructor(){
    super('/api/products');
  }
  responseHandler(response) {
    response.products.forEach((product)=> {
      product.price = parseFloat(product.price);
      product.buyCount = parseInt(product.buyCount);
      product.createdAt = new Date(product.createdAt);
      product.updatedAt = new Date(product.updatedAt);
      product.lastBoughtAt = product.lastBoughtAt ? new Date(product.lastBoughtAt) : null;
    });

    return response.products;
  }
}

export default new ProductStore();
