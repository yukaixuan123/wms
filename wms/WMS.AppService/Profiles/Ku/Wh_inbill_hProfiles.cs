using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Ku;
using WMS.Domain.Entity.Ku;

namespace WMS.AppService.Profiles.Ku
{
    public class Wh_inbill_hProfiles : Profile
    {
        public Wh_inbill_hProfiles() {

            CreateMap<AddWh_inbill_hDto, Wh_inbill_h>().ReverseMap();
            CreateMap<UpdateWh_inbill_hDto, Wh_inbill_h>().ReverseMap();
           
        }
    }
}
