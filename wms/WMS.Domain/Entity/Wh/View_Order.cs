using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class View_Order
    {
        public int buy_codeId { get; set; }
        public string buy_code { get; set; }
        public DateTime buy_date { get; set; }
        public string supply_code { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }
        public string buy_man { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public DateTime? update_time { get; set; }
        public string update_by { get; set; }
        public string sure_state { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string remark { get; set; }
        public string is_del { get; set; }
        public string sale_state { get; set; }
        public Decimal total_buy_num { get; set; }
        public Decimal total_price { get; set; }
        public string names { get; set; }

    }
}
