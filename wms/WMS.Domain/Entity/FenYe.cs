using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;

namespace WMS.Domain.Entity
{
    public class FenYe<T>
    {
        

        public FenYe(List<T> products, int totalCount, int page, int pageSize)
        {
            this.Data = products;
            this.totalCount = totalCount;
            this.page = page;
            this.pageSize = pageSize;
        }

        public List<T> Data { get; set; }
        public int totalCount { get; set; }
        public int page { get; set; }
        public int pageSize { get; set; }
        
    }
}
