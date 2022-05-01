eval
let fmt = t => (t < 10 ? '0' : '') + t;
let d = new Date();

`the time is ${fmt(d.getHours()%12)} ${d.getHours() < 12 ? 'AM' : 'PM'} for me`;