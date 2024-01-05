using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    /// <summary>
    /// 出库
    /// </summary>
    public class ST11
    {
        public int outbill_h_id { get; set; }
        public string outbill_code { get; set; }
        public string ware_code { get; set; }
        public string cust_code { get; set; }
        public string outbill_type { get; set; }
        public string outbill_state { get; set; }
        public string outbill_date { get; set; }
        public string sale_code { get; set; }
        public string duty_man { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string create_by { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }

        public Decimal total_buy_num { get; set; }

        public Decimal total_price { get; set; }

        public string names { get; set; }
        public DateTime create_time { get; set; }
    }
}
