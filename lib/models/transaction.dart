class SaleOrder {
  int id;
  String name; //nomor Struk
  String customer; //Customer Name
  String order_date; //Order Date
  String detail; //Payload Todos
  String pay_method; // Tunai / Cash / Debit
  double price_discount;
  double price_total;

  SaleOrder({
    this.id,
    this.name,
    this.customer,
    this.order_date,
    this.detail,
    this.pay_method,
    this.price_discount,
    this.price_total,
  });
}
