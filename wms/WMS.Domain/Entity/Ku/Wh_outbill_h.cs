using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 出库管理表
    /// </summary>
    public class Wh_outbill_h
    {
        public int outbill_h_id { get; set; }
        public string outbill_code { get; set; }
        public string outbill_type { get; set; }
        public DateTime outbill_date { get; set; }
        public string sale_code { get; set; }
        public string cust_code { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }
        public string duty_man { get; set; }
        public string ware_code { get; set; }
        public string create_by { get; set; }

        public DateTime create_time { get; set; }
        public DateTime? update_time { get; set; }
        public string update_by { get; set; }
        public string sure_state { get; set; }
        public string sure_man { get; set; }
        
        public DateTime? sure_date { get; set; }

        public string remark { get; set; }

        public string outbill_state { get; set; }

        public string is_del { get; set; }
    }
}
