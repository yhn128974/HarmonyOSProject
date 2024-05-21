export  function transTimeFormat(value: Date) {
  // 2023-12-23 05:12
  return value.getFullYear() + "-" + (value.getMonth() + 1).toString().padStart(2, "0") + '-'
    + value.getDate().toString().padStart(2, "0") + " " +
  value.getHours().toString().padStart(2, "0") + ":"
    + value.getMinutes().toString().padStart(2, "0")
}
