class SaleOrder {
  int id;

  /// nomor Struk
  ///
  /// Contoh : 18000-12-3
  String name;

  /// Nama Pelanggan
  ///
  /// Contoh : Irfan
  String customer;

  /// Date untuk disimpan dan Sortable. Karena di SQLITE tipenya harus Text
  ///
  /// Contoh : 2018-09-01 14:22:21
  String order_date;

  /// Data disimpan dalam bentuk JSON. Akan digunakan untuk Screen Transaction Details
  ///
  /// Contoh : {order_line: [{name: "Celana", quantity: 30 }]}
  String detail; //Payload Todos

  /// Contoh : Tunai / Cash / Debit
  String pay_method;
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
