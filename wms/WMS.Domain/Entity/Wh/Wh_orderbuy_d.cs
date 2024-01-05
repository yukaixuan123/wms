using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    /// <summary>
    /// 进货明细表
    /// </summary>
    public class Wh_orderbuy_d
    {
        public int buy_codeId { get; set; }
        public string buy_code { get; set; }
        public string item_name { get; set; }
        public string item_code { get; set; }
        public string model_code { get; set; }
        public string unit { get; set; }
        public string item_type_name { get; set; }
        public Decimal buy_num { get; set; }
        public Decimal treat_num { get; set; }

        public Decimal inbill_num { get; set; }
        public Decimal return_goods_num { get; set; }
        public Decimal buy_goods_money { get; set; }
        public string is_del { get; set; }
        public string remark { get; set; }

    }
}
