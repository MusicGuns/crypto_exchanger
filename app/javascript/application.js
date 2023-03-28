// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.getElementById("send").oninput = () => { reset_rate() };

setTimeout(() => { reset_rate() }, 30000);

document.addEventListener('turbo:render', () => { 
  reset_rate()
});

document.addEventListener('turbo:load', () => { 
  reset_rate()
});

async function reset_rate(){
  let rate = await fetch("/rate"); // false for synchronous request
  let send = document.getElementById('send').value;
  let res = Number(send);
  if(isNaN(res)){
      return;
  }
  let res_rate = +(await rate.text());
  let res_btc = res * res_rate;
  let res_fee = res_btc * 0.03;
  document.getElementById('get').setAttribute('value', `${res_btc}`);
  document.getElementById('fee').setAttribute('value', `${res_fee}`);
  document.getElementById('rate').setAttribute('value', `${res_rate}`);
}