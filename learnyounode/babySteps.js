const params = process.argv.slice(2,);

const p = params
  .filter(item => !isNaN(item))
  .map(item => Number(item))
  .reduce((acc,item) => acc + item, 0)

console.log(p);