using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    public class View_sale_return_h
    {
        public int sr_codeId { get; set; }
        public string sr_code { get; set; }
        public DateTime sr_date { get; set; }
        public string sale_code { get; set; }
        public string cust_code { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }
        public string sale_duty_man { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string sure_state { get; set; }
        public Decimal return_money { get; set; }
        public Decimal return_num { get; set; }
        public Decimal buy_price { get; set; }
        public string sale_state { get; set; }
        public string remark { get; set; }
        public string remarks { get; set; }
        public string is_del { get; set; }
        public string names { get; set; }
    }
}
