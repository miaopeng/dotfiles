
# shop_id = [11107571] # 抖音小店
shop_id = [10302818, 11705266, 11063409, 10100468] # 私域店铺

orders = ShopOrder.where(shop_id: shop_id).where(pay_date: DateTime.current.last_year.beginning_of_year..DateTime.current.last_month.end_of_month).where("paid_amount > 0");nil
# 成交总金额
orders.group_by_month(:pay_date, format: '%y-%m').sum(:paid_amount)

# 客户总数
orders.group_by { |order| order.pay_date.strftime("%y-%m") }.transform_values { |orders| orders.map(&:receiver_mobile).uniq.count }.sort.to_h

# 新客数（历史未购买）
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  res[date] = (users - old_users).count
  old_users = old_users | users
  res
end

# 其中：在当月复购的新客人数（购买>1次）
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  new_users = (_orders.map(&:receiver_mobile) - old_users)

  res[date] = new_users.select{ |e| new_users.count(e) > 1 }.uniq.count
  old_users = old_users | users
  res
end

# 新客成交金额
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  new_users = (users - old_users)
  res[date] = _orders.select { |o| new_users.include?(o[:receiver_mobile]) }.sum(&:paid_amount)
  old_users = old_users | users
  res
end

# 老客数
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  res[date] = (users - (users - old_users)).count
  old_users = old_users | users
  res
end

# 其中：当月交易两次以上的老客（大于等于2次）
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  ousers = (_orders.map(&:receiver_mobile) - (users - old_users))
  res[date] = ousers.select{ |e| ousers.count(e) > 1 }.uniq.count
  old_users = old_users | users
  res
end

# 老客成交金额
old_users = ShopOrder.where(shop_id: shop_id).where(ShopOrder.arel_table[:pay_date].lt(DateTime.current.last_year.beginning_of_year)).pluck(:receiver_mobile).uniq;nil

orders.group_by { |order| order.pay_date.strftime("%y-%m") }.sort.each_with_object({}) do |orders_by_date, res|
  date, _orders = orders_by_date
  users = _orders.map(&:receiver_mobile).uniq
  ousers = (users - (users - old_users))
  res[date] = _orders.select { |o| ousers.include?(o[:receiver_mobile]) }.sum(&:paid_amount)
  old_users = old_users | users
  res
end

# 平均产品价格（总金额/产品数）
orders = ShopOrder.where(shop_id: shop_id).where(pay_date: DateTime.current.last_year.beginning_of_year..DateTime.current.last_month.end_of_month).where("paid_amount > 0");nil
orders.group_by { |order| order.pay_date.strftime("%y-%m") }.transform_values { |_orders| _orders.sum(&:paid_amount) / ShopLineItem.where(shop_order_id: _orders.map(&:id)).where(is_gift: false).where('amount > 0').sum(:qty) }.sort.to_h