using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Bs;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Repository.Bs;

namespace WMS.AppService.AppService.Bs
{
    public class Bs_ware_areaAppService : IBs_ware_areaAppService
    {
        private readonly IBs_ware_areaRepository bs_Ware_AreaRepository;
        private readonly IMapper mapper;
        public Bs_ware_areaAppService(IBs_ware_areaRepository bs_Ware_AreaRepository, IMapper mapper)
        {
            this.bs_Ware_AreaRepository = bs_Ware_AreaRepository;
            this.mapper = mapper;
        }

        public Task<bool> Bs_ware_areaAdd(AddBs_ware_areaDto addBs_ware_areaDto)
        {
            Bs_ware_area bs_Ware_Area = mapper.Map<Bs_ware_area>(addBs_ware_areaDto);
            return bs_Ware_AreaRepository.Bs_ware_areaAdd(bs_Ware_Area);
        }

        public Task<int> Bs_ware_areaDel(DelBs_ware_areaDto delBs_ware_areaDto)
        {
            Bs_ware_area bs_Ware_Area = mapper.Map<Bs_ware_area>(delBs_ware_areaDto);
            return bs_Ware_AreaRepository.Bs_ware_areaDel(bs_Ware_Area);
        }

        public IEnumerable<Bs_ware_area> Bs_ware_areaFenYe(int page, int pageSize)
        {
            return bs_Ware_AreaRepository.Bs_ware_areaFenYe(page, pageSize);
        }

        public Task<List<Bs_ware_area>> Bs_ware_areaSelect()
        {
            return bs_Ware_AreaRepository.Bs_ware_areaSelect();
        }

        public Task<bool> Bs_ware_areaUpdate(UpdateBs_ware_areaDto updateBs_ware_areaDto)
        {
            Bs_ware_area bs_Ware_Area = mapper.Map<Bs_ware_area>(updateBs_ware_areaDto);
            return bs_Ware_AreaRepository.Bs_ware_areaUpdate(bs_Ware_Area);
        }

        public Task<bool> Bs_ware_areaRKDel(int id, string del)
        {
            return bs_Ware_AreaRepository.Bs_ware_areaRKDel(id, del);
        }
        public Task<bool> AreaDeleteAsync(int id, string str)
        {
            return bs_Ware_AreaRepository.AreaDeleteAsync(id, str);
        }

        public Task<int> AreaNameAsync(string name)
        {
            return bs_Ware_AreaRepository.AreaNameAsync(name);
        }

        public Task<FenYeSupply<Bs_ware_area>> FenYeWareAreaAsync(int currentPage, int pageSize, string str)
        {
            return bs_Ware_AreaRepository.FenYeWareAreaAsync(currentPage, pageSize, str);
        }

        public Task<bool> InsertAreaAsync(string code, string name, string cap, string man, int px, int zt, string cz, string gx, string bz, string dh,string cc)
        {
            return bs_Ware_AreaRepository.InsertAreaAsync(code, name, cap, man, px, zt, cz, gx, bz, dh,cc);
        }

        public Task<bool> PLDeleteArea(int[] num)
        {
            return bs_Ware_AreaRepository.PLDeleteArea(num);
        }

        public Task<Bs_ware_area> SelectIDAsync(int id)
        {
            return bs_Ware_AreaRepository.SelectIDAsync(id);
        }

        public Task<bool> UpdateAreaAsync(string code, string name, string cap, string man, string px, string zt, string gx, string bz, string dh, string id,string cc)
        {
            return bs_Ware_AreaRepository.UpdateAreaAsync(code, name, cap, man, px, zt, gx, bz, dh, id,cc);
        }
    }
}
