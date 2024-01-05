using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class PaiMing
    {
        public int number { get; set; }
        public string item_name { get; set; }
        public Decimal inbill_num { get; set; }
        public Decimal buy_price { get; set; }

        public int number1 { get; set; }
        public string item_name1 { get; set; }
        public Decimal outbill_num1 { get; set; }
        public Decimal sale_price1 { get; set; }

    }
}
