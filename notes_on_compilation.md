# Notes compiling Anura3D for Linux


Command to add ifort to path:
```source <install-dir>/bin/ifortvars.sh <arg>```

## File Compilation order
* GlobalConstants.f90
* A3DLinearElasticity.f90
* GeoMath.f90
* MatrixMath.f90
* FileIO.f90
* String.f90
* Counters.f90
* Feedback.f90
* ReadCalculationData.f90
* ElemCalcTETRA.f90
* ElemCalcQUAD.f90
* ReadMaterialData.f90 - Commented out the dll calls and set the dll handle to be a character for the time being. TODO:Needs work
* ElemCalcTRI.f90
* InitialiseKernel.f90
* ElemCalc.f90
* MeshInfo.f90
* ReadGeometryData.f90
* ISORT.f90
* ElemConnections.f90
* Particle.f90
* MPMData.f90
* RotBoundCond.f90
* MPMStresses.f90
* MPMDynViscousBoundary.f90
* TwoLayerFormulation.f90
* MPMDYN2PhaseSP.f90
* MPMDYN3PhaseSP.f90
* MPMDynContact.f90
* ReadMPMData.f90
* WriteMPMData.f90
* MPMMeshAdjustment.f90
* MPMConvPhase.f90
* WriteTestData.f90
* MPMEmptyElements.f90
* AdjustParticleDiscretisation.f90
* MPMInit.f90
* MPMDYNBTSig.f90
* RigidBody.f90
* LagrangianPhase.f90
* Liquid.f90
* ExternalSoilModel.f90
* MPMStrainSmoothing.f90
* MPMDYNStresses.f90
* MPMDYNConvPhase.f90
* MPMExcavation.f90
* BuildBJacDet.f90
* BuildDElastic.f90
* BuildLoad.f90
* GetPrinStress.f90
* GetStrain.f90
* A3DLinearElasticity.f90
* getversion.for
* InitialiseElementType.f90
* timing.f90
* WriteVTKASCII.f90
* WriteVTKBinary.f90
* WriteVTKOutput.f90
* WriteVTK2Layer.f90
* WriteNodalData.f90
* WriteResultData.f90
* ErrorHandler.f90 - Depends on MODWRITERESULTDATA,             WRITETIMESTEPRESULTS, MODERRORHANDLER
* MPMDynamicExplicit.f90 <!-- Needed to compile writeVTK and writeResult first therefore moved to after compiling FEMModules   -->
* Kernel.f90
* Anura3D.f90



#-------------------------------------#




## List of files (Once a file is compiled it's moved from here)




### FEMModules
* BuildBJacDet.FOR
* BuildDElastic.FOR
* BuildLoad.FOR
* ElemCalc.FOR
* ElemCalcQUAD.FOR
* ElemCalcTETRA.FOR
* ElemCalcTRI.FOR
* ElemConnections.FOR
* GetPrinStress.FOR
* GetStrain.FOR
* MeshInfo.FOR
* RotBoundCond.FOR

### InputModules
* ReadCalculationData.FOR
* ReadGeometryData.FOR
* ReadMaterialData.FOR
* ReadMPMData.FOR

### MaterialModels
* A3DLinearElasticity.f90
* ExternalSoilModel.f90
* Liquid.f90

### MPMModules
* AdjustParticleDiscretisation.FOR
* LagrangianPhase.FOR
* MPMConvPhase.FOR
* MPMData.FOR
* MPMDYN2PhaseSP.FOR
* MPMDYN3PhaseSP.FOR
* MPMDynamicExplicit.FOR
* MPMDYNBTSig.FOR
* MPMDynContact.FOR
* MPMDYNConvPhase.FOR
* MPMDYNStresses.FOR
* MPMDynViscousBoundary.FOR
* MPMEmptyElements.FOR
* MPMExcavation.FOR
* MPMInit.FOR
* MPMMeshAdjustment.FOR
* MPMStrainSmoothing.FOR
* MPMStresses.FOR
* Particle.FOR
* RigidBody.f
* TwoLayerFormulation.FOR

### OutputModules
* WriteMPMData.FOR
* WriteNodalData.FOR
* WriteResultData.FOR
* WriteTestData.FOR
* WriteVTK2Layer.FOR
* WriteVTKASCII.FOR
* WriteVTKBinary.FOR
* WriteVTKOutput.FOR

### Shared
* Counters.FOR
* ErrorHandler.for
* Feedback.for
* FileIO.for
* GeoMath.f90
* getversion.for
* GlobalConstants.f90
* InitialiseElementType.for
* InitialiseKernel.FOR
* ISORT.FOR
* MatrixMath.f90
* String.for
* timing.for

### Solver
* mkl_dss.f90
* Solver.FOR

## General Notes
use ./"Name of the Executable".out to 