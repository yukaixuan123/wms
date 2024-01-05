using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class ToYesCount
    {
        //入库今日
        public int To_Table1Count { get; set; }
        public Decimal To_total_buy_num { get; set; }
        public Decimal To_total_price { get; set; }
        //入库昨日
        public int Yes_Table1Count { get; set; }
        public Decimal Yes_total_buy_num { get; set; }
        public Decimal Yes_total_price { get; set; }


        //出库今日
        public int To_Table1Count1 { get; set; }
        public Decimal To_total_buy_num1 { get; set; }
        public Decimal To_total_price1 { get; set; }
        //出库昨日
        public int Yes_Table1Count1 { get; set; }
        public Decimal Yes_total_buy_num1 { get; set; }
        public Decimal Yes_total_price1 { get; set; }

    }
}
