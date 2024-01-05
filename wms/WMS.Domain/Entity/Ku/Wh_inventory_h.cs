using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Ku
{
    /// <summary>
    /// 盘点单表
    /// </summary>
    public class Wh_inventory_h
    {
        public int inventory_h_id { get; set; }
        public string inventory_code { get; set; }
        public string inventory_type { get; set; }
        public string ware_code { get; set; }
        public DateTime begin_date { get; set; }
        public DateTime end_date { get; set; }
        public string sure_state { get; set; }
        public string sure_man { get; set; }
        public string remark { get; set; }

        public DateTime sure_date { get; set; }
        public string zt { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
    }
}
