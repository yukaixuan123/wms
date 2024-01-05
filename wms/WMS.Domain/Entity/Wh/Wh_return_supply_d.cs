using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    /// <summary>
    /// 进货退货明细表
    /// </summary>
    public class Wh_return_supply_d
    {
        public int item_codeId { get; set; }
        public string returns_code { get; set; }
        public string item_code { get; set; }
        public string item_name { get; set; }
        public Decimal inbill3_num { get; set; }
        public Decimal return_goods_num { get; set; }
        public Decimal buy_price { get; set; }
        public Decimal return_money { get; set; }
        public string batch_no { get; set; }
        public string model_code { get; set; }
        public string is_del { get; set; }


    }
}
